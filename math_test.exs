# Module under test
defmodule MathTest do
  use EXam

  it "integers can be added and subtracted" do
    expect 1 + 1 == 2
    expect 2 + 3 == 5
    expect 5 - 5 == 10
  end

  it "integers can be multiplied and divided" do
    expect 5 * 5 == 25
    expect 10 / 2 == 5
    expect 10 / 5 == 3
  end
end
