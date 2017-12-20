require 'yasp'

Yasp.file('pizza.scad') do
  pizza = 160
  thickness = 10
  height = 20

  def sides(thickness)
    2.times do |i|
      rotate([0,0,-i * 360 / 8]) {
        translate([0,0,0]) {
          yield
        }
      }
    end
  end

  def ring(h, r, thickness)
    difference {
      cylinder(h: h, r: r, '$fn' => 120)
      cylinder(h: h, r: r - thickness, '$fn' => 120)
    }
  end

  outer_ring = assign do
  end


  union {
    # sphere(2)
    intersection {
      cube(1000)
      # cylinder(h: 1000, r: pizza + thickness/2, '$fn' => 120)
      rotate([0,0,360 / 8]) {
        cube(1000)
      }
      difference {
        union {
          cylinder(h: thickness, r: pizza + thickness / 2, '$fn' => 120)
          translate([0,0,thickness]){
            ring(height, pizza + thickness / 2, thickness)
          }
          translate([0,0,thickness + height]) {
            ring(3, pizza + thickness / 2, thickness / 1.5)
          }
          sides(thickness) do
            translate([0,0,thickness + height/2]) {
              cube([thickness, pizza*2, height], center = true);
            }
          end

          sides(thickness) do
            translate([0,0,thickness + height + 1.5]) {
              cube([thickness/1.5, pizza*2, 3], center = true);
            }
          end
        }
        ring(3, pizza + thickness / 1.5, thickness / 2)

        sides(thickness) do
          translate([0,0,1.5]) {
            # +12 fudge factor from adjusting the size of the bevel on the rim to 1.5 times
            cube([thickness/1.5, pizza*2 + 12, 3], center = true);
          }
        end
      }
    }
  }
end
