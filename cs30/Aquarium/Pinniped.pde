//import processing.sound.SoundFile;

enum SwimState { Idle, Ascending, Descending };

public class Pinniped extends AnimatedObject {
    int preferedDepth; // in meters
    float oxygenLevel;
    SwimState state;
    //SoundFile growlSound;
    int xDirection;

    Pinniped(float size) {
        super();
        this.size = size;

        oxygenLevel = 1;
        state = SwimState.Idle;
        preferedDepth = height / 2;

        x = (int)random(0, width);
        y = preferedDepth;
        xDirection = 1; // right

        // TODO: set in child classes
        xSpeed = 1;
        ySpeed = 1;

        //growlSound = null;
    }

    void move() {
        oxygenLevel -= 0.001;
        determineVelocity();

        y += ySpeed;
        x += xSpeed * xDirection;

        // Bounce of side walls
        if (x < 0 || x + size > width) {
            xDirection *= -1;
            x = max(0, min(x, width - size));
        }
    }

    void display() { // TODO: child class should override
        fill(255, 0, 0, (int)(oxygenLevel * 100));
        rect(x, y, 20, 20);
    }

    void sleep() {}

    // Cycle between the possible swim states
    void determineVelocity() {
        if (state == SwimState.Idle && oxygenLevel < 0) {
            state = SwimState.Ascending;
            ySpeed = -1; // TODO: original ySpeed * -1
            xSpeed = 0;
        }

        if (state == SwimState.Ascending && y < 0) {
            state = SwimState.Descending;
            ySpeed = 1.0; // TODO; original y speed
            xSpeed = 0;
        }

        if (state == SwimState.Descending && y >= preferedDepth) {
            state = SwimState.Idle;
            y = preferedDepth;
            oxygenLevel = random(0.5, 1.0);
        }

        if (state == SwimState.Idle) {
            // TODO: this is where the movement can vary from seal to seal
            xSpeed = 1; // TODO: reset xSpeed back to its original value
            ySpeed = sin(x + xSpeed) * 5; // follow the bending of a sine wave
        }
    }
}