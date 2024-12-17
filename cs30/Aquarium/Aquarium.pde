
class Circle {
    int radius;
    PVector pos;

    Circle(int radius, PVector position) {
        this.radius = radius;
        this.pos = position;
    }

    void moveTo(PVector target) {
        float angle = atan2(target.y - pos.y, target.x - pos.x);
        if (degrees(angle) > 270) angle = radians(270);
        float d = sqrt(pow(target.x - pos.x, 2) + pow(target.y - pos.y, 2)); // euclidean distance
        float gap = d - radius;
        if (gap < 0) return;
        pos.x += gap * cos(angle);
        pos.y += gap * sin(angle);
    }
}

class Chain {
    Circle[] circles;

    Chain() {
        int[] sizes = {5, 5, 10, 15, 15, 15, 15, 15};
        circles = new Circle[sizes.length];
        for (int i = 0; i < circles.length; i++) {
            circles[i] = new Circle(sizes[i], new PVector(i * sizes[i], 300));
        }
    }

    void update(int xSpeed) {
        float startX = circles[0].pos.x;
        PVector initial = new PVector(startX - 10, sin(startX) * 10);

        // Move and draw each piece of the chain
        // Make the chain move around using the mouse
        for (int i = 0; i < circles.length; i++) {
            Circle c = circles[i];
            circles[i].moveTo(i == 0 ? initial : circles[i - 1].pos);
            c.pos.x += xSpeed;
            circle(c.pos.x, c.pos.y, c.radius * 2);
        }
    }
}

Chain chain = new Chain();
Pinniped p = new Pinniped(100);

void setup() {
    size(600, 600);
}

void draw() {
    background(255);
    p.move();
    p.display();
}
