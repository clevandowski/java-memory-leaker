package fr.clevandowski.tools;

import java.util.ArrayList;
import java.util.List;

public class MemoryLeaker {
  public void generateOOM() {
    int iteratorValue = 1024;
    System.out.println("\n=================> OOM test started..\n");
    for (int outerIterator = 1; outerIterator < 20; outerIterator++) {
      System.out.println("Iteration " + outerIterator + " Free Mem: " + Runtime.getRuntime().freeMemory());
      int loop1 = 2;
      long[] memoryFillIntVar = new long[iteratorValue];
      // feel memoryFillIntVar array in loop..
      do {
        memoryFillIntVar[loop1] = 0;
        loop1--;
      } while (loop1 > 0);
      iteratorValue = iteratorValue * 2;
      System.out.println("\nRequired Memory for next loop: " + iteratorValue);
      try {
        Thread.sleep(1000);
      } catch (InterruptedException e) {
        throw new RuntimeException("WTF???", e);
      }
    }
  }
  
  private List<byte[]> consumedMemory;
   
  public void generateOOM2() {
    this.consumedMemory = new ArrayList<byte[]>();
    while (true) {
      byte b[] = new byte[1048576];
      this.consumedMemory.add(b);
      System.out.println("Free Mem: " + Runtime.getRuntime().freeMemory());
      try {
        Thread.sleep(50);
      } catch (InterruptedException e) {
        throw new RuntimeException("WTF???", e);
      }
    }
  }

  public void generateOOM3() {
    this.consumedMemory = new ArrayList<byte[]>();
    while (true) {
      long freeMemory = Runtime.getRuntime().freeMemory();
      int toCrunch = (int) freeMemory / 2;
      if (freeMemory < 1024*1024/2) {
//        int theBiggestIndex = this.getBiggestIndex(this.consumedMemory);
//        System.out.println("Removing " + this.consumedMemory.get(theBiggestIndex).length + " bytes");
//        this.consumedMemory.remove(theBiggestIndex);
        this.consumedMemory.remove(0);
      }
      if (toCrunch > 1024*1024/4) {
        toCrunch = 1024*1024/4;
      }
      if (toCrunch < 1024) {
        toCrunch = 1024;
      }
      System.out.println("Crunching " + toCrunch + " bytes");
      byte b[] = new byte[toCrunch];// new byte[1048576];
      for (int i = 0; i < toCrunch; i++) {
        b[i] = 0;
      }
      this.consumedMemory.add(b);
      System.out.println("Free Mem: " + Runtime.getRuntime().freeMemory() + " bytes, " + this.consumedMemory.size() + " elements consuming " + getGlobalLength(this.consumedMemory) + " bytes");
      try {
        Thread.sleep(100);
      } catch (InterruptedException e) {
        throw new RuntimeException("WTF???", e);
      }
    }
  }

  private int getBiggestIndex(List<byte[]> list) {
    int biggestIndex = 0;
    int biggestSize = 0;
    for (int i = 0; i < list.size(); i++) {
      byte[] bytes = list.get(i);
      if (bytes.length > biggestSize) {
        biggestIndex = i;
        biggestSize = bytes.length;
      }
    }
    return biggestIndex;
  }
  
  private long getGlobalLength(List<byte[]> listOfArraysOfBytes) {
    long total = 0;
    for(byte[] arrayOfBytes : listOfArraysOfBytes) {
      total += arrayOfBytes.length;
    }
    return total;
  }
}
