

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Array;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import de.l3s.boilerpipe.BoilerpipeProcessingException;
import de.l3s.boilerpipe.extractors.ArticleExtractor;

public class ReadCVS {

  public static void main(String[] args) throws BoilerpipeProcessingException {

	ReadCVS obj = new ReadCVS();
	obj.run();

  }

  public void run() {

	String csvFile = "smecko.csv";
	BufferedReader br = null;
	String line = "";
	String cvsSplitBy = ":";
	Pattern MY_PATTERN = Pattern.compile("http:.*");
    int errors = 0;
	try {
		
		
		br = new BufferedReader(new FileReader(csvFile));
		while ((line = br.readLine()) != null) {
			
				try {
					   URL url =
						        new URL(
						        		line.split(":", 2)[1]+"?piano_d=1"
						        );
					 
				        // use comma as separator
						String text;
						System.out.println(line.split(":", 2)[1]);
					text = new String(ArticleExtractor.INSTANCE.getText(url));
					File file = new File("/Users/Adam/sme_content/"+line.split(":", 2)[0]);
					FileWriter fw = new FileWriter(file.getAbsoluteFile());
					BufferedWriter bw = new BufferedWriter(fw);
					bw.write(text);
					bw.close();// be sure to close BufferedWriter
				} catch (Exception e) {
					errors += 1;
					System.out.println(errors);
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			
			
			
		}


	} catch (FileNotFoundException e) {
		e.printStackTrace();
	} catch (IOException e) {
		e.printStackTrace();
	} finally {
		if (br != null) {
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	System.out.println("Done");
  }

}