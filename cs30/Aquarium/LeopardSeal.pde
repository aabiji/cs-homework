//import processing.sound.SoundFile;

public class LeopardSeal extends Pinniped {
    LeopardSeal(float size) {
        super(size);
        this.size = size;

        preferedDepth = 15;
        xSpeed = 1;
        ySpeed = 1;
        velocity = new PVector(xSpeed, ySpeed);
    }

    void display() {
        fill(255, 0, 0, (int)(oxygenLevel * 100));
        rect(x, y, 20, 20);
    }
    void display( AnimatedObject[] objs ) { display(); }

    void move() {
        super.move(); // TODO: does this follow requirements???
    }

    void defineMovement() {
        if (state != SwimState.Idle) return;
        // TODO: this is where the movement can vary from seal to seal
        xSpeed = 1; // TODO: reset xSpeed back to its original value
        ySpeed = sin(x + xSpeed) * 5; // follow the bending of a sine wave
    }
}
