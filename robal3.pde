
int liczbarobali=1;
int liczbapokolen=500;
int pokolenie;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;
float grav=9.81;
float krokt=0.01;
float czas;
PFont czciona;

Zapis[] pokolenia= new Zapis[liczbapokolen];

Robal[] robale; 

class Zapis{
  float max=0,min=0;
}

void setup() {
  size(960, 480);
  
  czciona=createFont("Arial",16,true);
  textFont(czciona,16);

  //wczytajrobale();
  losujrobale();

  //robale[0]=new Robal();
  for (Robal robal: robale){
    robal.postaw();  
  }  
    
  noStroke();
  fill(255, 204);
  zapiszrobale();
  for(int i=0;i<liczbapokolen;i++)
  {
    pokolenia[i]=new Zapis();
  }
}

void wypiszwysokosci()
{
  println("wysokosci:");
  for (Robal robal: robale){
    
    
    println(robal+" "+str(robal.top));
    
  }
}

void symulujwszystkie()
{
  for(Robal robal:robale)
  {
    robal.move();
  }
}

void narysujtopy()
{
  strokeWeight(1);
  for (int i=1;i<liczbapokolen;i++)
  {
    line(10+(i-1)*5,height-10-(pokolenia[i-1].max/2),10+(5*i),height-10-(pokolenia[i].max/2));
    line(10+(i-1)*5,height-10-(pokolenia[i-1].min/2),10+(5*i),height-10-(pokolenia[i].min/2));
    
    
  }
}

void draw() {
  
  background(0);
  fill(255,0,0);
  text ("czas:"+str(czas),20,20);
  text ("pokolenie:"+str(pokolenie),20,40);
  fill(127);
  for (Robal robal: robale){
    robal.move();
    robal.display();
  }
  czas=czas+krokt;  
  if (czas>5){
    czas=0.0;
    pokolenie++;
    sortujrobale();  
    pokolenia[pokolenie].max=robale[0].top;
    pokolenia[pokolenie].min=robale[liczbarobali-1].top;
    wypiszwysokosci();
    przepiszrobale();
    mutujrobale();
  }
  narysujtopy();
  
}

void sortujrobale(){
  Robal tymczasowy; 
  for (int i=0;i<liczbarobali;i++)
    for (int j=i;j<liczbarobali;j++)
    {
      if (robale[i].top<robale[j].top)
      {
        tymczasowy=robale[i];
        robale[i]=robale[j];
        robale[j]=tymczasowy;
      }
      
    }
}


void przepiszrobale(){
  
  Robal tymczasowy;
  
  for (int i=0;i<liczbarobali/2;i++)
  {
    tymczasowy=robale[i].kopiuj();
  //  println("### kopia "+robale[i]+" "+tymczasowy);
    robale[i+liczbarobali/2]=tymczasowy;
    
  }
  
 // arrayCopy(robale,0,robale,liczbarobali/2,liczbarobali/2);
for (int i=0;i<liczbarobali;i++)
  {
    robale[i].top=0.0;
    robale[i].postaw();
  }  
}

void mutujrobale()
{
  for (int i=0;i<liczbarobali;i++)
  {robale[i].mutuj();}  
}

void losujrobale()
{
  liczbarobali=100;
  robale=new Robal[liczbarobali];
  for (int i=0;i<liczbarobali;i++)
  {
    robale[i]=new Robal();
    robale[i].l_stawy=3;
    for (int j=0;j<robale[i].l_stawy;j++){
      robale[i].stawy[j]=new Staw();
      robale[i].stawy[j].id=j;
      robale[i].stawy[j].x=random(10,100);
      robale[i].stawy[j].y=random(10,100);
      robale[i].stawy[j].vx=0.0;
      robale[i].stawy[j].vy=0.0;
      robale[i].stawy[j].ax=0.0;
      robale[i].stawy[j].ay=0.0;
    }
    
    robale[i].l_kosci=3;
    robale[i].kosci= new Kosc[robale[i].l_kosci];
    for (int j=0;j<robale[i].l_kosci;j++){
      robale[i].kosci[j]=new Kosc();
    }
      robale[i].kosci[0].s1=robale[i].stawy[0];robale[i].kosci[0].s2=robale[i].stawy[1];
      robale[i].kosci[1].s1=robale[i].stawy[1];robale[i].kosci[1].s2=robale[i].stawy[2];
      robale[i].kosci[2].s1=robale[i].stawy[2];robale[i].kosci[2].s2=robale[i].stawy[0];
     for (int j=0;j<robale[i].l_kosci;j++){
       Staw s1r=robale[i].kosci[j].s1;
       Staw s2r=robale[i].kosci[j].s2;
       robale[i].kosci[j].dlugosc=sqrt((s1r.x-s2r.x)*(s1r.x-s2r.x)+(s1r.y-s2r.y)*(s1r.y-s2r.y));
       robale[i].kosci[j].amp=robale[i].kosci[j].dlugosc/random(50,100);
       robale[i].kosci[j].t=random(5,40); //20
       robale[i].kosci[j].fi=random(0,5);   
     }
    }    
}


void wczytajrobale(){
  String[] koddna=loadStrings("robaki2.txt");
  int nrlinii=0;
  liczbarobali=int(koddna[0]);
  robale=new Robal[liczbarobali];
  nrlinii++;
  for (int i=0;i<liczbarobali;i++)
  {
    robale[i]=new Robal();
    String l1=koddna[nrlinii];nrlinii++;
    robale[i].l_stawy=int(l1);
    robale[i].stawy= new Staw[robale[i].l_stawy];
    for (int j=0;j<robale[i].l_stawy;j++){
      robale[i].stawy[j]=new Staw();
      robale[i].stawy[j].id=j;
      String[] l2=koddna[nrlinii].split(",");nrlinii++;
      robale[i].stawy[j].x=float(l2[0]);
      robale[i].stawy[j].y=float(l2[1]);
      robale[i].stawy[j].sx=robale[i].stawy[j].x;
      robale[i].stawy[j].sy=robale[i].stawy[j].y;
     
      robale[i].stawy[j].vx=float(l2[2]);
      robale[i].stawy[j].vy=float(l2[3]);
      robale[i].stawy[j].ax=float(l2[4]);
      robale[i].stawy[j].ay=float(l2[5]);
      
      l2=koddna[nrlinii].split(",");nrlinii++;
      robale[i].stawy[j].masa=float(l2[0]);
      robale[i].stawy[j].sprezystosc=float(l2[1]);
      robale[i].stawy[j].diam=float(l2[2]);
    }
    l1=koddna[nrlinii];nrlinii++;
    robale[i].l_kosci=int(l1);
    robale[i].kosci= new Kosc[robale[i].l_kosci];
    for (int j=0;j<robale[i].l_kosci;j++){
      robale[i].kosci[j]=new Kosc();
      String[] l2=koddna[nrlinii].split(", ");nrlinii++;
  /*
      println(l2);
      println("intl1"+l2[0]);
      println("intl2"+l2[1]);      
  */    
      robale[i].kosci[j].s1=robale[i].stawy[int(l2[0])];
      robale[i].kosci[j].s2=robale[i].stawy[int(l2[1])];
      /*
      println(robale[i].kosci[j].s1.id+" ("+int(l2[0]));
      println(robale[i].kosci[j].s2.id+" ("+int(l2[1]));
      */
      
      
      l2=koddna[nrlinii].split(",");nrlinii++;      //<>//
  //    println(l2[0]);
      robale[i].kosci[j].dlugosc=float(l2[0]);
 //     println("dlugosc"+robale[i].kosci[j].dlugosc);
      robale[i].kosci[j].amp=float(l2[1]);
      robale[i].kosci[j].t=float(l2[2]);
      robale[i].kosci[j].fi=float(l2[3]);      
      
      
    }
    
    
    

    
  }
}

void zapiszrobale(){
  PrintWriter output = createWriter("robakilosowe.txt");
  output.println(liczbarobali);
  for (int i=0;i<liczbarobali;i++){
    output.println(robale[i].l_stawy);
    for (int j=0;j<robale[i].l_stawy;j++)
    {
      Staw st=robale[i].stawy[j];
      output.println(st.x+", "+st.y+", "+st.vx+", "+st.vy+", "+st.ax+", "+st.ay);
      output.println(st.masa+", "+st.sprezystosc+", "+st.diam);
    }
    output.println(robale[i].l_kosci);    
    for (int j=0;j<robale[i].l_kosci;j++)
    {
      Kosc st=robale[i].kosci[j];
      output.println(st.s1.id+", "+st.s2.id);
      output.println(st.dlugosc+", "+st.amp+", "+st.t+", "+st.fi);
    }
    
  }
  output.flush();
  output.close();
}

  

class Staw{
  int id;
  float sx,sy,x,y,vx,vy,ax,ay;
  float masa=10;
  float sprezystosc=0.8;
  float diam=10;
  
  void move()
  {
    vy += ay-gravity;
    vx += ax;
    x += vx;
    y += vy;
    if (x + diam/2 > width) {
      x = width - diam/2;
      vx *= -sprezystosc; 
    }
    else if (x - diam/2 < 0) {
      x = diam/2;
      vx *= -sprezystosc;
    }
    /*if (y + diam/2 > height) {
      y = height - diam/2;
      vy *= -sprezystosc; 
    } 
    else */
    if (y - diam/2 < 0) {
      y = diam/2;
      vy *= -sprezystosc;
    }
  }
    

  
}

class Kosc
{
  Staw s1,s2;
  float dlugosc;
  float amp,t,fi;
  
  void move()
  {
    float dl=(sqrt((s1.x-s2.x)*(s1.x-s2.x)+(s1.y-s2.y)*(s1.y-s2.y)));
    float dlp=dlugosc+amp*sin(t*czas+fi);
    float deltad=dl-dlp;
    float sila=deltad;
 //   println(dlugosc);

    s1.ax+=sila*((s2.x-s1.x)/dl)/s1.masa;
    s1.ay+=sila*((s2.y-s1.y)/dl)/s1.masa;
    
    s2.ax+=sila*((s1.x-s2.x)/dl)/s2.masa;
    s2.ay+=sila*((s1.y-s2.y)/dl)/s2.masa;
    
    
  };
  
}

class Sciegno
{
  Kosc k1,k2;
}

class Robal{
  Staw[] stawy;
  Kosc[] kosci;
  Sciegno[] sciegna;
  int l_stawy,l_kosci,l_sciegna;
  float top=0.0;
  
  Robal()
  {
    
    l_stawy=4;
    l_kosci=4;
    l_sciegna=3;   
    stawy= new Staw[l_stawy];
    kosci= new Kosc[l_kosci];
    sciegna= new Sciegno[l_sciegna];
    for (int i=0;i<l_stawy;i++) stawy[i]=new Staw();
    for (int i=0;i<l_kosci;i++) kosci[i]=new Kosc();
    for (int i=0;i<l_sciegna;i++) sciegna[i]=new Sciegno();
    
    
    stawy[0].x=10;stawy[0].y=10;stawy[0].id=0;
    stawy[1].x=10;stawy[1].y=50;stawy[1].id=1;
    stawy[2].x=50;stawy[2].y=10;stawy[2].id=2;
    stawy[3].x=50;stawy[3].y=50;stawy[3].id=3;
    
    kosci[0].s1=stawy[0];kosci[0].s2=stawy[1];
    kosci[1].s1=stawy[1];kosci[1].s2=stawy[2];
    kosci[2].s1=stawy[2];kosci[2].s2=stawy[0];
    kosci[3].s1=stawy[0];kosci[3].s2=stawy[3];
   
    
    for (int i=0;i<l_kosci;i++)
    {
      Staw s1=kosci[i].s1;
      Staw s2=kosci[i].s2;
      kosci[i].dlugosc=sqrt((s1.x-s2.x)*(s1.x-s2.x)+(s1.y-s2.y)*(s1.y-s2.y));
      kosci[i].amp=kosci[i].dlugosc/100;
      kosci[i].t=20;
      kosci[i].fi=0;
    }
   

    
 //   sciegna[0].k1=kosci[0];sciegna[0].k2=kosci[1];
  //  sciegna[1].k1=kosci[1];sciegna[1].k2=kosci[2];
  //  sciegna[2].k1=kosci[2];sciegna[2].k2=kosci[0];
  //  sciegna[2].k1=kosci[0];sciegna[2].k2=kosci[3];    
    
    
  
  }
  void mutuj(){
    float prawd=0.3;
    for (int i=0;i<l_kosci;i++){
      if(random(10)<prawd){
        kosci[i].dlugosc*=random(0.9,1.1);
      }
    }
        
    
  }
  
  Robal kopiuj()
  {
    Robal nowy = new Robal();
    nowy.l_stawy=l_stawy;
    nowy.l_kosci=l_kosci;
    nowy.l_sciegna=l_sciegna;
    nowy.stawy= new Staw[l_stawy];
    nowy.kosci= new Kosc[l_kosci];
    nowy.sciegna= new Sciegno[l_sciegna];
    for (int i=0;i<l_stawy;i++) 
    {
      nowy.stawy[i]=new Staw();
      nowy.stawy[i].x=stawy[i].x;
      nowy.stawy[i].y=stawy[i].y;      
      nowy.stawy[i].vy=stawy[i].vy;
      nowy.stawy[i].ay=stawy[i].ay;
      nowy.stawy[i].vx=stawy[i].vx;
      nowy.stawy[i].ax=stawy[i].ax;
      
      
      nowy.stawy[i].masa=stawy[i].masa;
      nowy.stawy[i].id=stawy[i].id;
      nowy.stawy[i].sprezystosc=stawy[i].sprezystosc;      
      nowy.stawy[i].diam=stawy[i].diam;      
    }
    for (int i=0;i<l_kosci;i++)
    {
      nowy.kosci[i]=new Kosc();
      nowy.kosci[i].s1=nowy.stawy[kosci[i].s1.id];
      nowy.kosci[i].s2=nowy.stawy[kosci[i].s2.id];
      nowy.kosci[i].dlugosc=kosci[i].dlugosc;
      nowy.kosci[i].amp=kosci[i].amp;
      nowy.kosci[i].t=kosci[i].t;
      nowy.kosci[i].fi=kosci[i].fi;
      
   
    }
    for (int i=0;i<l_sciegna;i++) nowy.sciegna[i]=new Sciegno();    
    
    return nowy;
  }
  
  void move()  
  {
    float mtop=stawy[0].y;
    for(int i=0;i<l_stawy;i++)
    {
      stawy[i].ax=0;
      stawy[i].ay=0;
    }
    
    
    for(int i=0;i<l_kosci;i++)
    {
      kosci[i].move();
    }
    for(int i=0;i<l_stawy;i++)
    {
      stawy[i].move();
      if (stawy[i].y<mtop) mtop=stawy[i].y;
    }
    if (top<mtop) top=mtop;
    
  }
  
  void display()
  {
     stroke(127);
     strokeWeight(2);
     /*
     for (int i=0;i<l_sciegna;i++)
     {
       Kosc k1=sciegna[i].k1;
       Kosc k2=sciegna[i].k2;

       float x1=(k1.s1.x+k1.s2.x)/2.0;
       float y1=(k1.s1.y+k1.s2.y)/2.0;
       
       float x2=(k2.s1.x+k2.s2.x)/2.0;
       float y2=(k2.s1.y+k2.s2.y)/2.0;
       
       line(x1,y1,x2,y2);
     }
     */

    stroke(255);
     strokeWeight(4);
     for (int i=0;i<l_kosci;i++)
     {
       line(kosci[i].s1.x,height-kosci[i].s1.y,kosci[i].s2.x,height-kosci[i].s2.y);
     }
     
     for(int i=0;i<l_stawy;i++)
     {
       ellipse(stawy[i].x,height-stawy[i].y,10,10);
    
     }
     fill(255,0,0);
     text (str(top),stawy[0].x,height-stawy[0].y);
     fill(127);

  }
  
  void postaw()
  {
    for(int i=0;i<l_stawy;i++)
    {
 //     stawy[i].x=stawy[i].sx;
 //     stawy[i].y=stawy[i].sy;
    }
    float maxx=stawy[0].x,maxy=stawy[0].y;
    float minx=stawy[0].x,miny=stawy[0].y;
    for(int i=0;i<l_stawy;i++)
    {
      if (maxx<stawy[i].x) maxx=stawy[i].x;
      if (maxy<stawy[i].y) maxy=stawy[i].y;
      if (minx>stawy[i].x) minx=stawy[i].x;
      if (miny>stawy[i].y) miny=stawy[i].y;      
    }
   for (int i=0;i<l_stawy;i++)
   {
     stawy[i].x+=(width-maxx-minx)/2.0;
     stawy[i].y-=((maxy+miny)/2.0-40);
   }
  }
  
}