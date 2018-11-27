package fr.clevandowski.tools;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@EnableAutoConfiguration
public class MemoryLeakerApplication {
  
  private MemoryLeaker memoryLeaker = new MemoryLeaker();
  
  @RequestMapping("/")
  @ResponseBody
  private String home() {
    return "Coin Coin !!!\n";
  }

  @RequestMapping("/leak")
  @ResponseBody
  private void leak() {
    memoryLeaker.generateOOM();
  }
  
  @RequestMapping("/leak2")
  @ResponseBody
  private void leak2() {
    memoryLeaker.generateOOM2();
  }

  @RequestMapping("/leak3")
  @ResponseBody
  private void leak3() {
    memoryLeaker.generateOOM3();
  }

  public static void main(String[] args) {
    SpringApplication.run(MemoryLeakerApplication.class, args);
  }
}
