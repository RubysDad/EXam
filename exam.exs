defmodule EXam do
  #  This macro injects the stubbed exam function into the test module
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :tests, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def exam, do: EXam.Test.exam(@tests, __MODULE__)
    end
  end

  defmacro it(description, do: it_block) do
    it_func = String.to_atom(description)
    quote do
      @tests {unquote(it_func), unquote(description)}
      def unquote(it_func)(), do: unquote(it_block)
    end
  end

  defmacro expect({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      EXam.Test.expect(operator, lhs, rhs)
    end
  end
end

defmodule EXam.Test do
  def exam(tests, module) do
    Enum.each tests, fn {test_func, description} ->
      case apply(module, test_func, []) do
        :ok -> IO.write "."
        {:fail, reason} -> IO.puts """
          ============================
          FAILURE: #{description}
          ============================
          #{reason}
        """
      end
    end
  end

  def expect(:==, lhs, rhs) when lhs == rhs do
    :ok
  end

  def expect(:==, lhs, rhs) do
    {:fail, "Expected: #{lhs} to equal #{rhs}"}
  end

  def expect(:>, lhs, rhs) when lhs > rhs do
    :ok
  end

  def expect(:>, lhs, rhs) do
    {:fail, "Expected: #{lhs} to be greater than #{rhs}"}
  end
end
