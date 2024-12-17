//import processing.sound.SoundFile;

enum SwimState { Idle, Ascending, Descending };

public class Pinniped extends AnimatedObject {
    int preferedDepth; // in meters
    float oxygenLevel;

    int xDirection;
    PVector velocity;

    SwimState state;
    //SoundFile growlSound;

    Pinniped(float size) {
        super();
        this.size = size;

        oxygenLevel = 1;
        state = SwimState.Idle;
        preferedDepth = height / 2;

        x = (int)random(0, width);
        y = preferedDepth;
        xDirection = 1; // right

        xSpeed = 0;
        ySpeed = 0;
        velocity = new PVector(0, 0);
        //growlSound = null;
    }

    // Methods defined by the child class
    void display() {}
    void defineMovement() {}

    void move() {
        defineMovement();

        y += velocity.y;
        x += velocity.x * xDirection;
        oxygenLevel -= 0.001;

        // Bounce of side walls
        if (x < 0 || x + size > width) {
            xDirection *= -1;
            x = max(0, min(x, width - size));
        }
    }

    void sleep() {} // TODO!

    // Cycle between the possible swim states
    void setSwimState() {
        if (state == SwimState.Idle && oxygenLevel < 0) {
            state = SwimState.Ascending;
            velocity.x = xSpeed * -1;
            velocity.y = 0;
        }

        if (state == SwimState.Ascending && y < 0) {
            state = SwimState.Descending;
            velocity.x = xSpeed;
            velocity.y = 0;
        }

        if (state == SwimState.Descending && y >= preferedDepth) {
            state = SwimState.Idle;
            y = preferedDepth;
            oxygenLevel = random(0.5, 1.0);
        }
    }
}