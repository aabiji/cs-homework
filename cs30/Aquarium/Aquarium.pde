

class Circle {
    int radius;
    PVector pos;

    Circle(int radius, PVector position) {
        this.radius = radius;
        this.pos = position;
    }

    void moveTo(PVector target) {
        float angle = atan2(target.y - pos.y, target.x - pos.x);
        float d = sqrt(pow(target.x - pos.x, 2) + pow(target.y - pos.y, 2));
        // TODO: prevemt chain kinking
        if (d > radius) { // radius is the original distance between the 2 circles centers
            pos.x += (d - radius) * cos(angle);
            pos.y += (d - radius) * sin(angle);
        }
    }
}

class Chain {
    Circle[] circles;

    Chain() {
        circles = new Circle[8];
        for (int i = 0; i < circles.length; i++) {
            circles[i] = new Circle(25, new PVector(i * 25, 300));
        }
    }

    void update() {
        // Move and draw each piece of the chain
        // Make the chain move around using the mouse
        for (int i = 0; i < circles.length; i++) {
            Circle c = circles[i];
            PVector t = i == 0 ? new PVector(mouseX, mouseY) : circles[i - 1].pos;
            circles[i].moveTo(t);
            fill(i == 0 ? color(255, 0, 0) : color(255, 255, 255));
            circle(c.pos.x, c.pos.y, c.radius * 2);
        }
    }
}

Chain chain = new Chain();

void setup() {
    size(600, 600);
}

void draw() {
    background(255);
    chain.update();
}
