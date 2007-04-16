module Cairo
  module Color
    class Base
      attr_accessor :alpha

      alias_method :a, :alpha
      alias_method :a=, :alpha=

      def initialize(a)
        @alpha = a
      end
    end

    class RGB < Base
      attr_accessor :red, :green, :blue

      alias_method :r, :red
      alias_method :r=, :red=
      alias_method :g, :green
      alias_method :g=, :green=
      alias_method :b, :blue
      alias_method :b=, :blue=

      def initialize(r, g, b, a=1.0)
        super(a)
        @red = r
        @green = g
        @blue = b
      end

      def to_a
        [@red, @green, @blue, @alpha]
      end
      alias_method :to_ary, :to_a

      def to_rgb
        clone
      end

      def to_cmyk
        cmy = [1.0 - @red, 1.0 - @green, 1.0 - @blue]
        key_plate = cmy.min
        if key_plate < 1.0
          one_k = 1.0 - key_plate
          cmyk = cmy.collect {|value| (value - key_plate) / one_k} + [key_plate]
        else
          cmyk = [0, 0, 0, key_plate]
        end
        cmyka = cmyk + [@alpha]
        CMYK.new(*cmyka)
      end
    end

    class CMYK < Base
      attr_accessor :cyan, :magenta, :yellow, :key_plate

      alias_method :c, :cyan
      alias_method :c=, :cyan=
      alias_method :m, :magenta
      alias_method :m=, :magenta=
      alias_method :y, :yellow
      alias_method :y=, :yellow=
      alias_method :k, :key_plate
      alias_method :k=, :key_plate=

      def initialize(c, m, y, k, a=1.0)
        super(a)
        @cyan = c
        @magenta = m
        @yellow = y
        @key_plate = k
      end

      def to_a
        [@cyan, @magenta, @yellow, @key_plate, @alpha]
      end
      alias_method :to_ary, :to_a

      def to_rgb
        one_k = 1.0 - @key_plate
        rgba = [
                (1.0 - @cyan) * one_k,
                (1.0 - @magenta) * one_k,
                (1.0 - @yellow) * one_k,
                @alpha,
               ]
        RGB.new(*rgba)
      end

      def to_cmyk
        clone
      end
    end
  end
end