import java.io.*;

public class ExpandROM {
	public static void main(String[] args) {
		try {
			FileInputStream fis = new FileInputStream(new File(args[0]));
			int aaa = 0;
			FileOutputStream fos = new FileOutputStream("expanded.bin");
			while(fis.available() > 0) {
				fos.write(fis.read());
				aaa++;
			}
			for(int i = aaa; i < 512*1024; i++) fos.write(0xFF);
			fos.close();
			fis.close();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
