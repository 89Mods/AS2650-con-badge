import java.io.*;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

public class FramesToROM {
	public static void main(String[] args) {
		try {
			//BufferedWriter bw = new BufferedWriter(new FileWriter(new File("ba_combined.txt")));
			/*FileInputStream fis = new FileInputStream("ba.bin");
			FileOutputStream fos = new FileOutputStream("ba_combined.bin");
			for(int i = 0; i < 8192; i++) {
				int v = fis.read() & 0xFF;
				fos.write(v);
				bw.write(Integer.toHexString(v));
				bw.newLine();
			}
			fis.close();*/
			File framesFolder = new File("frames");
			if(!framesFolder.exists()) {
				System.out.println("Frames folder not found");
				if(new File("frames.bin").exists()) {
					System.out.println("...but frames.bin exists, so probably fine");
					System.exit(0);
				}else System.exit(1);
			}
			FileOutputStream fos = new FileOutputStream("frames.bin");
			int fileCount = framesFolder.listFiles().length;
			for(int i = 0; i < fileCount; i++) {
				BufferedImage img = ImageIO.read(new File(String.format("frames/frame%04d.png", i + 1)));
				if(img.getWidth() != 43 || img.getHeight() != 32) throw new Exception("Frame not of right size");
				for(int k = 0; k < 32; k++) {
					int curr = 0;
					for(int j = 0; j < 43; j++) {
						curr >>= 1;
						int rgb = img.getRGB(j, k) & 0xFF;
						if(rgb > 150) curr |= 128;
						if((j + 1) % 8 == 0) {
							fos.write(curr);
							//bw.write(Integer.toHexString(curr));
							//bw.newLine();
						}
					}
					curr >>= 5;
					fos.write(curr);
					//bw.write(Integer.toHexString(curr));
					//bw.newLine();
				}
			}
			fos.close();
			//bw.close();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
