import ddf.minim.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

Minim minim;
AudioInput input;
AudioOutput output;
AudioRecorder recorder;
FilePlayer player;
BandPass bpf;

PImage img0,img1,img2;

int cnt=0;

void setup()
{
  size(360, 640);
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 2048);
  recorder = minim.createRecorder(input, "myrecording.wav");
  
  img0 = loadImage("parrotNormal.jpg");
  img1 = loadImage("parrotEar.jpg");
  img2 = loadImage("parrotTalking.jpg");
}

void draw()
{
  background(0); 
  stroke(255);
  if (cnt%3==1)
  {
    image(img1,0,0);
  }
  else if(cnt%3==2)
  {
    image(img2,0,0);
  }
  else{
    image(img0,0,0);
  }
}

void mouseClicked()
{
  cnt++;
  if ( cnt%3==1 ) 
  { 
    recorder.beginRecord();
  }
  else if ( cnt%3==2 )
  {
    if ( recorder.isRecording() ) 
    {
      recorder.endRecord();
    }
    if ( player != null )
    {
        player.close();
    }
    recorder.save();
    output = minim.getLineOut();
    player = new FilePlayer(minim.loadFileStream("myrecording.wav"));
    bpf = new BandPass(900,20,output.sampleRate());
    player.patch(bpf).patch(output);
    delay(3000);
    player.play();
  }
}

void stop()
{
  input.close();
  if ( player != null )
  {
    player.close();
  }
  minim.stop();
  super.stop();
}
