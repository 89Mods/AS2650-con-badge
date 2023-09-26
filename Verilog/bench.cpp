#include "Vtb.h"
#include "verilated.h"
#include "Vtb___024root.h"
#include <iostream>
namespace sc = std::chrono;

#include <gtkmm.h>

class LEDPanel : public Gtk::DrawingArea {
	public:
		LEDPanel() {
			set_content_width(64*8);
			set_content_height(32*8);
			
			set_draw_func(sigc::mem_fun(*this, &LEDPanel::on_draw));
			m_image = Gdk::Pixbuf::create(Gdk::Colorspace::RGB, false, 8, 64*8, 32*8);
			m_image->fill(0);
			
			set_pixel(3, 3, 255, 255, 0);
		}
		virtual ~LEDPanel() {}
		
		void set_pixel(int x, int y, int r, int g, int b) {
			if(x < 0 || y < 0 || x >= 64 || y >= 32) return;
			for(int i = 0; i < 8; i++) for(int j = 0; j < 8; j++) set_smol_pixel(x * 8 + i, y * 8 + j, r, g, b);
		}
	
	protected:
		void on_draw(const Cairo::RefPtr<Cairo::Context>& cr, int width, int height) {
			Gdk::Cairo::set_source_pixbuf(cr, m_image, 0, 0);
			cr->paint();
		}
		void set_smol_pixel(int x, int y, int r, int g, int b) {
			if(!m_image) return;
			int offset = y*m_image->get_rowstride() + x*m_image->get_n_channels();
			guchar * pixel = &m_image->get_pixels()[offset];
			if(!pixel) return;
			pixel[0] = r;
			pixel[1] = g;
			pixel[2] = b;
		}
		Glib::RefPtr<Gdk::Pixbuf> m_image;
};

class MainWindow : public Gtk::Window {
	public:
		MainWindow() {
			set_title("LED Panel");
			set_default_size(64*8, 32*8);
			set_child(m_ledpanel);
			
			auto controller = Gtk::EventControllerKey::create();
			controller->signal_key_pressed().connect(sigc::mem_fun(*this, &MainWindow::on_key_pressed), false);
			controller->signal_key_released().connect(sigc::mem_fun(*this, &MainWindow::on_key_released), false);
			add_controller(controller);
			
#ifdef TRACE_ON
			printf("Warning: tracing is ON!\r\n");
			Verilated::traceEverOn(true);
#endif
			top.clk = 0;
			top.rst = 0;
			clocks(4);
			top.rst = 1;
			
			sigc::slot<bool()> my_slot = sigc::bind(sigc::mem_fun(*this, &MainWindow::on_timeout), 0);
			/*auto conn = */Glib::signal_timeout().connect(my_slot, 100);
		}
		virtual ~MainWindow() {}
	
	protected:
		uint8_t controller_state = 0xFF;
		uint8_t full_combo = 0;
		LEDPanel m_ledpanel;
		Vtb top;
		uint64_t total_clocks = 0;
		bool on_timeout(int timer_number) {
			//uint64_t start_time = sys_time();
			//clocks(210000);
			clocks(90000);
			//printf("%ld\r\n", sys_time() - start_time);
			
			int page = top.rootp->tb__DOT__computer__DOT__cpld__DOT__vram_page ? (8 << 8) : 0;
			for(int i = 0; i < 32; i++) for(int j = 0; j < 64; j++){
				//int r = (top.rootp->tb__DOT__computer__DOT__LED_Panel__DOT__frame_r[i] >> j) & 1;
				//int g = (top.rootp->tb__DOT__computer__DOT__LED_Panel__DOT__frame_g[i] >> j) & 1;
				//int b = (top.rootp->tb__DOT__computer__DOT__LED_Panel__DOT__frame_b[i] >> j) & 1;
				int rgb = top.rootp->tb__DOT__computer__DOT__vram__DOT__memory[i * 64 + j + page];
				int r = rgb & 0b11100000;
				int g = rgb & 0b00011100;
				int b = rgb & 0b00000011;
				m_ledpanel.set_pixel(j, i, (r >> 5) * 36, (g >> 2) * 36, b * 85);
			}
			m_ledpanel.queue_draw();
			top.tb_controller_state = controller_state;
			if(full_combo) controller_state = 0xFF;
			full_combo = 0;
			
			//int testval = top.rootp->tb__DOT__computer__DOT__RAM__DOT__memory[3840+5];
			//int testval2 = top.rootp->tb__DOT__computer__DOT__RAM__DOT__memory[3840+6];
			//int testval3 = top.rootp->tb__DOT__computer__DOT__RAM__DOT__memory[3840+24];
			//int testval4 = top.rootp->tb__DOT__computer__DOT__RAM__DOT__memory[3840+25];
			//printf("%d,%d -> %d,%d\r\n", testval, testval2, testval3, testval4);
			
			if(Verilated::gotFinish()) {
				top.final();
			}
			
			return !Verilated::gotFinish();
		}
		bool on_key_pressed(guint keyval, guint, Gdk::ModifierType state) {
			if(keyval == GDK_KEY_Escape) {
				top.final();
				hide();
			}
			if(keyval == GDK_KEY_w) {
				controller_state &= ~8;
			}
			if(keyval == GDK_KEY_a) {
				controller_state &= ~2;
			}
			if(keyval == GDK_KEY_s) {
				controller_state &= ~4;
			}
			if(keyval == GDK_KEY_d) {
				controller_state &= ~1;
			}
			if(keyval == GDK_KEY_y) {
				controller_state &= ~16;
			}
			if(keyval == GDK_KEY_x) {
				controller_state &= ~32;
			}
			if(keyval == GDK_KEY_n) {
				controller_state &= ~64;
			}
			if(keyval == GDK_KEY_m) {
				controller_state &= ~128;
			}
			if(keyval == GDK_KEY_o) {
				controller_state = 0;
				full_combo = 1;
			}
			return true;
		}
		void on_key_released(guint keyval, guint, Gdk::ModifierType state) {
			if(keyval == GDK_KEY_w) {
				controller_state |= 8;
			}
			if(keyval == GDK_KEY_a) {
				controller_state |= 2;
			}
			if(keyval == GDK_KEY_s) {
				controller_state |= 4;
			}
			if(keyval == GDK_KEY_d) {
				controller_state |= 1;
			}
			if(keyval == GDK_KEY_y) {
				controller_state |= 16;
			}
			if(keyval == GDK_KEY_x) {
				controller_state |= 32;
			}
			if(keyval == GDK_KEY_n) {
				controller_state |= 64;
			}
			if(keyval == GDK_KEY_m) {
				controller_state |= 128;
			}
		}
		int64_t sys_time() {
			auto time = sc::system_clock::now();
			auto since_epoch = time.time_since_epoch();
			auto millis = sc::duration_cast<sc::milliseconds>(since_epoch);
			return millis.count();
		}
		void clocks(int c) {
			for(int i = 0; i < c*2; i++) {
				Verilated::timeInc(1);
				top.clk = !top.clk;
				top.eval();
				if(i % 2 == 0) total_clocks++;
				if(Verilated::gotFinish()) return;
			}
		}
};

double sc_time_stamp() { return 0; }

int main(int argc, char** argv, char** env) {
	auto app = Gtk::Application::create("net.tholin.ef_badge");
	return app->make_window_and_run<MainWindow>(argc, argv);
}
