import java.io.BufferedWriter;
import java.io.FileWriter;
import java.math.*;
import java.util.*;

public class Main {

    public static void main(String[] args) throws Exception{
        BufferedWriter ws=new BufferedWriter(new FileWriter("../prime.txt"));
        for(int i=0;i<100;i++)
        {
            BigInteger bi;
            int bitLength = 50;//1024;
            Random rnd = new Random();
            bi = BigInteger.probablePrime(bitLength, rnd);
            System.out.println(bi.toString());
            ws.write(bi.toString());
            ws.newLine();
        }
        ws.close();
    }
}
