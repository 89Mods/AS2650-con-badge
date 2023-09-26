import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;

public class ROMGlue {
	public static void main(String[] args) {
		try {
			File rootBin = new File(args[0]);
			if(!rootBin.exists()) {
				System.err.println("Root binary file not found");
				System.exit(1);
			}
			int[] bitmapTable = new int[512];
			int[] bitmapData = new int[65536];
			int bitmapDataPtr = 0;
			for(int i3 = 0; i3 < 128; i3++) {
				File f = new File(String.format("Bitmaps/src/%03d_bw.png", i3));
				if(f.exists()) {
					System.out.println("Found source image (grey) for bitmap slot " + i3);
					BufferedImage img = ImageIO.read(f);
					if(img.getWidth() > 64 || img.getHeight() > 32) throw new Exception("Image too large! 64x32 max!");
					if(img.getWidth() % 8 != 0) throw new Exception("Image width on bitmap not a multiple of 8");
					int[] data = new int[img.getWidth()/8*img.getHeight()];
					int curr = 0;
					int ptr = 0;
					for(int i = 0; i < img.getHeight(); i++) {
						for(int j = 0; j < img.getWidth(); j++) {
							int rgb = img.getRGB(j, i);
							curr >>= 1;
							if((rgb & 0xFF) > 32) curr |= 128;
							if((j + 1) % 8 == 0) {
								data[ptr] = curr;
								curr = 0;
								ptr++;
							}
						}
					}
					bitmapTable[i3*4+0] = bitmapDataPtr & 0xFF;
					bitmapTable[i3*4+1] = bitmapDataPtr >> 8;
					bitmapTable[i3*4+2] = img.getWidth();
					bitmapTable[i3*4+3] = img.getHeight();
					for(int i = 0; i < ptr; i++) {
						bitmapData[bitmapDataPtr] = data[i];
						bitmapDataPtr++;
					}
					continue;
				}
				
				f = new File(String.format("Bitmaps/src/%03d_c.png", i3));
				if(f.exists()) {
					System.out.println("Found source image (color) for bitmap slot " + i3);
					BufferedImage img = ImageIO.read(f);
					if(img.getWidth() > 64 || img.getHeight() > 32) throw new Exception("Image too large! 64x32 max!");
					int[] data = new int[img.getWidth()*img.getHeight()];
					for(int i = 0; i < img.getHeight(); i++) {
						for(int j = 0; j < img.getWidth(); j++) {
							int rgb = img.getRGB(j, i);
							int red = (rgb & 0xFF0000) >> (5 + 16);
							int green = (rgb & 0x00FF00) >> (5 + 8);
							int blue = (rgb & 0x0000FF) >> (6 + 0);
							data[i * img.getWidth() + j] = (red << 5) | (green << 2) | blue;
						}
					}
					
					bitmapTable[i3*4+0] = bitmapDataPtr & 0xFF;
					bitmapTable[i3*4+1] = bitmapDataPtr >> 8;
					bitmapTable[i3*4+2] = img.getWidth();
					bitmapTable[i3*4+3] = img.getHeight();
					for(int i = 0; i < data.length; i++) {
						bitmapData[bitmapDataPtr] = data[i];
						bitmapDataPtr++;
					}
					continue;
				}
			}
			System.out.println(String.format("%d/65536 bytes (%#.2f%%) of bitmap data used (%d bytes free)", bitmapDataPtr, (float)bitmapDataPtr / 65536.0f * 100.0f, 65536 - bitmapDataPtr));
			
			int[] appTable = new int[512];
			int appNum = 0;
			final int appPointerBase = 8192 + 512 + 65536 + 512;
			int appPointer = appPointerBase;
			int app0Ptr = appPointer;
			File app0 = new File("Software/BadgeIdle/badge.bin");
			File app0_data0 = new File("Software/BadgeIdle/badge_highmem.bin");
			File app0_data1 = new File("Software/BadgeIdle/three_dee.bin");
			File app0_data2 = new File("Avali.bin");
			System.out.println("Avali.bin len: " + app0_data2.length());
			int app0Length = (int)(app0.length() - 4096);
			int app0DataLength = 4096 + 4096 + (int)app0_data2.length();
			appTable[appNum*32+0] = appPointer & 0xFF;
			appTable[appNum*32+1] = (appPointer >> 8) & 0xFF;
			appTable[appNum*32+2] = (appPointer >> 16) & 0xFF;
			appTable[appNum*32+3] = (int)(app0Length & 0xFF);
			appTable[appNum*32+4] = (int)((app0Length >> 8) & 0xFF);
			appPointer += app0Length;
			appTable[appNum*32+5] = appPointer & 0xFF;
			appTable[appNum*32+6] = (appPointer >> 8) & 0xFF;
			appTable[appNum*32+7] = (appPointer >> 16) & 0xFF;
			appTable[appNum*32+8] = app0DataLength & 0xFF;
			appTable[appNum*32+9] = (app0DataLength >> 8) & 0xFF;
			appTable[appNum*32+10] = (app0DataLength >> 16) & 0xFF;
			appTable[appNum*32+11] = 5;
			appTable[appNum*32+12] = 'B';
			appTable[appNum*32+13] = 'a';
			appTable[appNum*32+14] = 'd';
			appTable[appNum*32+15] = 'g';
			appTable[appNum*32+16] = 'e';
			appPointer += app0DataLength;
			appNum++;
			File app1 = new File("Software/BA/ba.bin");
			File app1_data0 = new File("Software/BA/frames.bin");
			int app1Length = (int)(app1.length() - 4096);
			int app1DataLength = (int)(app1_data0.length());
			appTable[appNum*32+0] = appPointer & 0xFF;
			appTable[appNum*32+1] = (appPointer >> 8) & 0xFF;
			appTable[appNum*32+2] = (appPointer >> 16) & 0xFF;
			appTable[appNum*32+3] = (int)(app1Length & 0xFF);
			appTable[appNum*32+4] = (int)((app1Length >> 8) & 0xFF);
			appPointer += app1Length;
			appTable[appNum*32+5] = appPointer & 0xFF;
			appTable[appNum*32+6] = (appPointer >> 8) & 0xFF;
			appTable[appNum*32+7] = (appPointer >> 16) & 0xFF;
			appTable[appNum*32+8] = app1DataLength & 0xFF;
			appTable[appNum*32+9] = (app1DataLength >> 8) & 0xFF;
			appTable[appNum*32+10] = (app1DataLength >> 16) & 0xFF;
			appTable[appNum*32+11] = 2;
			appTable[appNum*32+12] = 'B';
			appTable[appNum*32+13] = 'A';
			appPointer += app1DataLength;
			appNum++;
			File app2 = new File("Software/Snake/snake.bin");
			int app2Length = (int)(app2.length() - 4096);
			appTable[appNum*32+0] = appPointer & 0xFF;
			appTable[appNum*32+1] = (appPointer >> 8) & 0xFF;
			appTable[appNum*32+2] = (appPointer >> 16) & 0xFF;
			appTable[appNum*32+3] = (int)(app2Length & 0xFF);
			appTable[appNum*32+4] = (int)((app2Length >> 8) & 0xFF);
			appPointer += app2Length;
			appTable[appNum*32+5] = appPointer & 0xFF;
			appTable[appNum*32+6] = (appPointer >> 8) & 0xFF;
			appTable[appNum*32+7] = (appPointer >> 16) & 0xFF;
			appTable[appNum*32+8] = 0;
			appTable[appNum*32+9] = 0;
			appTable[appNum*32+10] = 0;
			appTable[appNum*32+11] = 5;
			appTable[appNum*32+12] = 'S';
			appTable[appNum*32+13] = 'n';
			appTable[appNum*32+14] = 'a';
			appTable[appNum*32+15] = 'k';
			appTable[appNum*32+16] = 'e';
			appNum++;
			
			int appdataTotal = 4194304 - appPointerBase;
			int appBytesUsed = appPointer - appPointerBase;
			System.out.println(String.format("%d/%d bytes (%#.2f%%) of app data used (%d bytes free)", appBytesUsed, appdataTotal, (float)appBytesUsed / (float)appdataTotal * 100.0f, appdataTotal - appBytesUsed));
			
			BufferedWriter bw = new BufferedWriter(new FileWriter(new File("compiled.txt")));
			FileOutputStream fos = new FileOutputStream("compiled.bin");
			int aaaa = 0;
			FileInputStream fis = new FileInputStream(rootBin);
			for(int i = 0; i < 8192; i++) {
				int val = fis.read() & 0xFF;
				fos.write(val);
				bw.write(Integer.toHexString(val));
				bw.newLine();
				aaaa++;
			}
			fis.close();
			for(int i = 0; i < bitmapTable.length; i++) {
				fos.write(bitmapTable[i]);
				aaaa++;
				bw.write(Integer.toHexString(bitmapTable[i]));
				bw.newLine();
			}
			for(int i = 0; i < bitmapData.length; i++) {
				fos.write(bitmapData[i]);
				bw.write(Integer.toHexString(bitmapData[i]));
				aaaa++;
				bw.newLine();
			}
			for(int i = 0; i < appTable.length; i++) {
				aaaa++;
				fos.write(appTable[i]);
				bw.write(Integer.toHexString(appTable[i]));
				bw.newLine();
			}
			
			File[] appDataFiles = {app0, app0_data0, app0_data1, app0_data2, app1, app1_data0, app2};
			int[] skipLen = {4096, 4096, 4096, 0, 4096, 0, 4096};
			int[] enforceLen = {0, 4096, 4096, 0, 0, 0, 0};
			for(int k = 0; k < appDataFiles.length; k++) {
				fis = new FileInputStream(appDataFiles[k]);
				fis.skip(skipLen[k]);
				int length = enforceLen[k] == 0 ? (int)(appDataFiles[k].length() - skipLen[k]) : enforceLen[k];
				for(int i = 0; i < length; i++) {
					int val = fis.read() & 0xFF;
					fos.write(val);
					bw.write(Integer.toHexString(val));
					bw.newLine();
					aaaa++;
				}
				fis.close();
			}
			
			for(int i = aaaa; i < 4*1024*1024; i++) fos.write(0xFF);
			
			fos.close();
			bw.close();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
