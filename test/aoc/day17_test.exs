defmodule AOC.Day17Test do
  use ExUnit.Case, async: true
  alias AOC.Day17

  setup do
    input = [
      "x=495, y=2..7",
      "y=7, x=495..501",
      "x=501, y=3..7",
      "x=498, y=2..4",
      "x=506, y=1..2",
      "x=498, y=10..13",
      "x=504, y=10..13",
      "y=13, x=498..504"
    ]

    {:ok, map: Day17.parse(input)}
  end

  test "parse", %{map: map} do
    assert map == %Day17{
             map: %{
               {498, 4} => {:solid, :clay},
               {501, 6} => {:solid, :clay},
               {500, 13} => {:solid, :clay},
               {495, 6} => {:solid, :clay},
               {496, 7} => {:solid, :clay},
               {497, 7} => {:solid, :clay},
               {506, 2} => {:solid, :clay},
               {504, 12} => {:solid, :clay},
               {506, 1} => {:solid, :clay},
               {501, 7} => {:solid, :clay},
               {504, 10} => {:solid, :clay},
               {495, 4} => {:solid, :clay},
               {500, 7} => {:solid, :clay},
               {499, 13} => {:solid, :clay},
               {495, 7} => {:solid, :clay},
               {498, 2} => {:solid, :clay},
               {498, 11} => {:solid, :clay},
               {501, 4} => {:solid, :clay},
               {498, 7} => {:solid, :clay},
               {498, 13} => {:solid, :clay},
               {495, 3} => {:solid, :clay},
               {498, 3} => {:solid, :clay},
               {498, 12} => {:solid, :clay},
               {501, 13} => {:solid, :clay},
               {501, 5} => {:solid, :clay},
               {495, 2} => {:solid, :clay},
               {495, 5} => {:solid, :clay},
               {503, 13} => {:solid, :clay},
               {504, 13} => {:solid, :clay},
               {502, 13} => {:solid, :clay},
               {499, 7} => {:solid, :clay},
               {501, 3} => {:solid, :clay},
               {498, 10} => {:solid, :clay},
               {504, 11} => {:solid, :clay}
             },
             xrange: 494..507,
             yrange: 1..13
           }
  end

  test "to_string", %{map: map} do
    assert to_string(map) == """
           ............#.
           .#..#.......#.
           .#..#..#......
           .#..#..#......
           .#.....#......
           .#.....#......
           .#######......
           ..............
           ..............
           ....#.....#...
           ....#.....#...
           ....#.....#...
           ....#######...\
           """
  end

  test "wet", %{map: map} do
    wet = Day17.wet(map)

    assert to_string(wet) == """
           ......|.....#.
           .#..#.|.....#.
           .#..#.|#......
           .#..#.|#......
           .#....|#......
           .#|||||#......
           .#######......
           ..............
           ..............
           ....#.....#...
           ....#.....#...
           ....#.....#...
           ....#######...\
           """
  end

  test "dry", %{map: map} do
    dry =
      map
      |> Day17.wet()
      |> Day17.dry()

    assert to_string(dry) == """
           ............#.
           .#..#.......#.
           .#..#..#......
           .#..#..#......
           .#.....#......
           .#~~~~~#......
           .#######......
           ..............
           ..............
           ....#.....#...
           ....#.....#...
           ....#.....#...
           ....#######...\
           """
  end

  test "run", %{map: map} do
    finished = Day17.run(map)

    assert to_string(finished) == """
           ......|.....#.
           .#..#||||...#.
           .#..#~~#|.....
           .#..#~~#|.....
           .#~~~~~#|.....
           .#~~~~~#|.....
           .#######|.....
           ........|.....
           ...|||||||||..
           ...|#~~~~~#|..
           ...|#~~~~~#|..
           ...|#~~~~~#|..
           ...|#######|..\
           """
  end
end
