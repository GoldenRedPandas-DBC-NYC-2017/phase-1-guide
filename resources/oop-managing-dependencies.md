# Managing Dependencies

An object has a dependency when it knows:
- The name of another class
- The name of a message that it intends to send to someone other than self
- The arguments that a message requires
- The order of those arguments

With OOP, your goal is to manage dependencies so that each class has the fewest possible -- a class should know just enough to do its job and not one thing more.

Here are some techniques for reducing dependencies in your code:

### Injecting Dependencies

"Dependency Injection" is a 25-dollar term for a 5-cent concept. Dependency Injection is the design of objects where they receive instances of the objects from other pieces of code instead of constructing them internally.

So, instead of:
```ruby
class Car
  def initialize
    @driver = Person.new
  end
end
```

We "inject" the dependency in the constructor:
```ruby
class Car
  def initialize(person)
    @driver = person
  end
end
```

This means that any object implementing the interface which is required by the object can be substituted in without changing the code, which simplifies testing, and improves decoupling. It's a very useful technique for testing, since it allows us to isolate classes and mock or stub out dependencies easily.

### Isolating Dependencies

When a class contains embedded references to a message that is likely to change, isolating the reference provides some insurance against being affected by that change.

Starting with:
```ruby
def Car
  def driver_comfort
    foo = some_intermediate_result * driver.age
  end
end
```

We isolate the external message by wrapping it in another method:
```ruby
def Car
  def driver_comfort
    foo = some_intermediate_result * driver_age
  end

  def driver_age
    driver.age
  end
end
```

Now if the interface of driver changes, we will only have to alter our Car class in one place. Although not every external method is a candidate for this preemptive isolation, it’s worth examining your code, looking for and wrapping the most vulnerable dependencies.

An alternative way to eliminate these side effects is to avoid the problem from the very beginning by reversing the direction of the dependency.

### Remove argument-order dependencies

We have three arguments that need to be passed in order.
```ruby
def initialize(color, manufacturer, driver)
  @color        = color
  @manufacturer = manufacturer
  @driver       = driver
end
```

Instead, we use hashes for initialization arguments. The order of arguments is no longer fixed.
```ruby
def initialize(args)
  @color        = args[:color]
  @manufacturer = args[:manufacturer]
  @driver       = args[:driver]
end
```

Even better, explicitly define defaults:
```ruby
def initialize(args)
  @color        = args.fetch(:color, "white")
  @manufacturer = args.fetch(:manufacturer, "Toyota")
  @driver       = args[:driver]  
end
```

### Dependency Inversion

Be conscious about the direction of your dependencies &mdash; build classes that
depend on things that change less often than they do.  The Dependency Inversion
Principle is primarily about reversing the conventional direction of
dependencies from "higher level" components to "lower level" components such
that "lower level" components are dependent upon the interfaces owned by the
"higher level" components. That sounds fancy, but you likely do this
intuitively.

Which of these scenarios makes more sense?

#### Scenario 1

    class Car
      def initialize(default_wheels=[])
        @wheels += default_wheels
      end

      def needs_tire_replacement?
        @wheels.any? { |wheel| wheel.damaged? }
      end
    end

    class Wheel
      def initialize(brand="Goodyear", size=nil)
        @brand = brand
        @size = size
        @damage_points = 5
      end

      def damaged?
        @damage_points < 2
      end
    end



#### Scenario 2

    class Wheel
      def initialize(car=nil, brand="Goodyear", size=nil)
        @car = car
        raise "I need a car to be on!" unless car
        @car.add_wheel(self)
        @brand = brand
        @size = size
        @damage_points = 5
      end

      def damaged?
        @damage_points < 2
      end
    end

    class Car
      def initialize(default_wheels=[])
        @wheels += default_wheels
      end

      def needs_tire_replacement?
        @wheels.any? { |wheel| wheel.damaged? }
      end

      def add_wheel(wheel)
        @wheels << wheel
      end
    end

Look at Scenario 2's `Wheel` definition. Is it _reasonable_ that in order for a
`Wheel` to exist, a `Car` must exist? Of course not. In a simple example like
this, realize which way the dependency directions ought go is intuitive based
on our experience of the physical world. Let's try to make this slightly more
interesting by having a `Doll` that can wear a seasonal outfit.

    class Doll
      attr_accessible :clothing

      def initialize(brand, material)
        @clothing = []
      end
    end

We want to add a method called `dress_for_summer`.

    def dress_for_summer
      @clothing = ["hat", "sunglasses", "sunscreen"]
    end

But then we have to add one for Winter:

    def dress_for_summer
      @clothing = ["scarf", "parka", "gloves"]
    end

We can easily imagine adding methods for Spring and Fall. But wait, stop a
second.  **WHY** does a `Doll` know about the clothing that's appropriate for a
season? Dolls are vaguely human-like representations. Why would they know that?
And if someone said "Add 'swimsuit' to the summer clothing," would it make sense
to open up a file called `doll.rb`? We've fallen into the subtle trap of
getting the dependency wrong. What if we did this...

    class SummerDresser
      def initialize(clothes_wearer)
        @clothes_wearer = clothes_wearer
      end

      def dress
        @clothes_wearer.clothing = ["hat", "sunglasses", "sunscreen"]
      end
    end

`SummerDresser` can now dress anything that shares access to a `clothing`
instance variable (a `Doll`, a `Person`, some `Dog` might). If someone says
that in Summer we need to add a `"swimsuit"`, doesn't it make sense to open
`summer_dresser.rb`?

In doing so, coupling isn't reduced so much as it is shifted from components
that are theoretically less valuable for reuse (`Doll`) to components which are
theoretically more valuable for reuse (`SummerDresser`). Many object
orientation educational materials refer to things in the real world `Dog`s or
`Car`s, but a great insight about OOP is that objects can be any noun including
_processes_, _behaviors_, _policies_. Just because it isn't _tangible_, doesn't
mean it isn't _real_ and thus able to be modeled cleverly with OOP.

Realizing all these opportunities is something that comes with experience and
time, but being aware that these possibilities exist ("Gee, why is that `Doll`
class so darn long? And why's it full of all these weird fashion policies?")
will provide opportunity for further learning as you're more able to tackle and
integreate it.

