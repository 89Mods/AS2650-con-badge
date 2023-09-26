import java.io.*;
import java.util.*;

public class ObjParser {
	private class Vertex {
		public double x,y,z;
		public Vertex(double x, double y, double z) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		public String toString() {
			return String.format("[%#.3f, %#.3f, %#.3f]", x, y, z);
		}
	}
	
	private static int toFixed(double d) {
		double d2 = Math.abs(d);
		int res = (int)(d2 * 65536.0);
		if(d < 0) {
			res ^= 0xFFFFFF;
			res += 1;
		}
		return res;
	}
	
	private static String fixedToDB(int fixed) {
		int hex1 = (fixed >> 16) & 0xFF;
		int hex2 = (fixed >> 8) & 0xFF;
		int hex3 = (fixed >> 0) & 0xFF;
		return String.format("db 0x%02x,0x%02x,0x%02x", hex1, hex2, hex3);
	}
	
	private void writeFixed(int fixed, FileOutputStream fos) throws Exception {
		fos.write((fixed >> 16) & 0xFF);
		fos.write((fixed >> 8) & 0xFF);
		fos.write((fixed >> 0) & 0xFF);
	}
	
	public ObjParser(){}
	public void parse(File in, File out, double objScale, double zOffset) {
		try {
			int totalFaces = 0;
			BufferedReader br = new BufferedReader(new FileReader(in));
			FileOutputStream fos = new FileOutputStream(out);
			List<Vertex> verts = new ArrayList<Vertex>();
			List<Vertex> vertColors = new ArrayList<Vertex>();
			while(true) {
				String line = br.readLine();
				if(line == null) break;
				if(line.startsWith("v ")) {
					String[] parts = line.substring(2).split(" ");
					verts.add(new Vertex(
						Double.parseDouble(parts[0]) * objScale,
						Double.parseDouble(parts[1]) * objScale,
						Double.parseDouble(parts[2]) * objScale + zOffset
					));
					if(parts.length < 6) vertColors.add(new Vertex(1,1,1));
					else vertColors.add(new Vertex(
						Double.parseDouble(parts[3]),
						Double.parseDouble(parts[4]),
						Double.parseDouble(parts[5])
					));
				}
				if(line.startsWith("f ")) {
					String[] parts = line.substring(2).split(" ");
					if(parts.length != 3) throw new Exception("ERROR: obj file does not consist only of tris");
					Vertex[] faceVerts = new Vertex[3];
					Vertex[] faceColors = new Vertex[3];
					for(int i = 0; i < 3; i++) {
						int idx = Integer.parseInt(parts[i].split("/")[0]);
						faceVerts[i] = verts.get(idx - 1);
						faceColors[i] = vertColors.get(idx - 1);
					}
					//Vertex tmp = faceVerts[1];
					//faceVerts[1] = faceVerts[2];
					//faceVerts[2] = tmp;
					Vertex p1 = new Vertex(faceVerts[1].x - faceVerts[0].x, faceVerts[1].y - faceVerts[0].y, faceVerts[1].z - faceVerts[0].z);
					Vertex p2 = new Vertex(faceVerts[2].x - faceVerts[0].x, faceVerts[2].y - faceVerts[0].y, faceVerts[2].z - faceVerts[0].z);
					Vertex normal = new Vertex(
						p1.y * p2.z - p1.z * p2.y,
						p1.z * p2.x - p1.x * p2.z,
						p1.x * p2.y - p1.y * p2.x
					);
					for(int i = 0; i < 3; i++) {
						int f1 = toFixed(faceVerts[i].x);
						int f2 = toFixed(faceVerts[i].y);
						int f3 = toFixed(faceVerts[i].z);
						System.out.println(fixedToDB(f1));
						System.out.println(fixedToDB(f2));
						System.out.println(fixedToDB(f3));
						System.out.println();
						
						writeFixed(f1, fos);
						writeFixed(f2, fos);
						writeFixed(f3, fos);
					}
					double len = Math.sqrt(normal.x * normal.x + normal.y * normal.y + normal.z * normal.z);
					normal.x /= len;
					normal.y /= len;
					normal.z /= len;
					int fn1 = toFixed(normal.x);
					int fn2 = toFixed(normal.y);
					int fn3 = toFixed(normal.z);
					System.out.println(fixedToDB(fn1));
					System.out.println(fixedToDB(fn2));
					System.out.println(fixedToDB(fn3));
					writeFixed(fn1, fos);
					writeFixed(fn2, fos);
					writeFixed(fn3, fos);
					
					/*double red = faceColors[0].x + faceColors[1].x + faceColors[2].x;
					red /= 3;
					double green = faceColors[0].y + faceColors[1].y + faceColors[2].y;
					green /= 3;
					double blue = faceColors[0].z + faceColors[1].z + faceColors[2].z;
					blue /= 3;*/
					
					double red = normal.x > 0 ? normal.x : 0;
					double green = normal.y > 0 ? normal.y : 0;
					double blue = normal.z > 0 ? normal.z : 0;
					//double red = normal.x > 0 ? 1 : 0;
					//double green = normal.y > 0 ? 1 : 0;
					//double blue = normal.z > 0 ? 1 : 0;
					if(normal.x < 0) {
						double a = -normal.x;
						green = (1 - a) * green + a;
						blue = (1 - a) * blue + a;
					}
					if(normal.y < 0) {
						double a = -normal.y;
						red = (1 - a) * red + a;
						blue = (1 - a) * blue + a;
					}
					if(normal.z < 0) {
						double a = -normal.z;
						red = (1 - a) * red + a;
						green = (1 - a) * green + a;
					}
					
					//double bright = Math.max(0, Math.min(1, normal.z));
					//double red = 0;
					//double green = bright;
					//double blue = 0;
					
					int redI = (int)(red * 8);
					if(redI > 7) redI = 7;
					int greenI = (int)(green * 8);
					if(greenI > 7) greenI = 7;
					int blueI = (int)(blue * 4);
					if(blueI > 3) blueI = 3;
					
					int colI = (redI << 5) | (greenI << 2) | blueI;
					System.out.println(String.format("db 0x%02x", colI));
					totalFaces++;
					
					fos.write(colI);
				}
			}
			System.out.println(totalFaces + " total faces");
			
			fos.close();
			br.close();
		}catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		}
	}
	public static void main(String[] args) {
		if(args.length != 2) {
			System.err.println("ObjParser [infile.obj] [outfile.bin]");
			System.exit(1);
		}
		new ObjParser().parse(new File(args[0]), new File(args[1]), 0.37, 0);
	}
}
