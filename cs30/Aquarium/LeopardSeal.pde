//import processing.sound.SoundFile;

public class LeopardSeal extends Pinniped {
    int preferedDepth;
    float oxygenLevel;
    PVector frontFlipperSize;
    PVector backFlipperSize;
    //SoundFile growlSound;

    LeopardSeal(float size) {
        super(size);
        this.size = size;

        oxygenLevel = 1;
        preferedDepth = 15;
        frontFlipperSize = new PVector(7, 4); // todo: fix this
        backFlipperSize = new PVector(0, 0);
    }

    void move() {
        x += xSpeed;
        y += ySpeed;
    }

    void display() { }
    void display( AnimatedObject[] objs ) { display(); }

    void surface() {} // Come up for air
    void sleep() {}
    void swim() {}
}
