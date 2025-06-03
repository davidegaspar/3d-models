$fn = 100;

innerDiameter = 40;
outterDiameter = 50;
slotHeight = 7;
gripDiameter = 2;
angleIncrement = 4;

difference()
{
    linear_extrude(20) union()
    {
        difference()
        {
            circle(d = outterDiameter);
            circle(d = innerDiameter);
#translate([ innerDiameter / 2, 0, 0 ]) square(size = slotHeight, center = true);
        }
        for (a = [0:angleIncrement:360])
        {
            rotate([ 0, 0, a ]) translate([ outterDiameter / 2, 0, 0 ]) circle(d = gripDiameter);
        }
    }
}