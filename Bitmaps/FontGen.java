import java.io.*;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;

public class FontGen {
	public static void main(String[] args) {
		try {
			if(args.length == 0) {
				System.err.println("Missing argument");
				System.exit(1);
				return;
			}
			File infile = new File(args[0]);
			if(!infile.exists()) {
				System.err.println("File not found");
				System.exit(1);
				return;
			}
			BufferedImage in = ImageIO.read(infile);
			if(in.getWidth() % 8 != 0 || in.getHeight() % 8 != 0) {
				System.err.println("Image width or height not divisible by 8");
				System.exit(1);
				return;
			}
			int charsPerRow = in.getWidth() / 8;
			int charsPerCol = in.getHeight() / 8;
			int totalCharsInImage = charsPerRow * charsPerCol;
			if(totalCharsInImage < 95) {
				System.err.println("Not enough characters in image! Needs 95 (all printable ASCII chars).");
				System.exit(1);
				return;
			}
			for(int i = 0; i < 95; i++) {
				System.out.print("db ");
				for(int j = 0; j < 8; j++) {
					int val = 0;
					for(int k = 0; k < 8; k++) {
						int rgb = in.getRGB((i % charsPerRow) * 8 + k, (i / charsPerRow) * 8 + j);
						val >>= 1;
						if((rgb & 0xFF) > 25) val |= 128;
					}
					System.out.print(String.format("0x%02x", val));
					if(j != 7) System.out.print(",");
				}
				System.out.println();
			}
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
}
