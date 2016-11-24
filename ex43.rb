# frozen_string_literal: true

# Scene
class Scene
  def enter
    puts 'This scene is not yet configured. Subclass it and implement enter().'
    exit(1)
  end

  def ask_user(question, prompt = '> ')
    print question, prompt
    $stdin.gets.chomp
  end
end

# Engine
class Engine
  def initialize(scene_map)
    @scene_map = scene_map
  end

  def play
    current_scene = @scene_map.opening_scene
    last_scene = @scene_map.next_scene(:finished)

    while current_scene != last_scene
      next_scene_name = current_scene.enter
      current_scene = @scene_map.next_scene(next_scene_name)
    end

    # Be sure to print out the last scene
    current_scene.enter
  end
end

# Scene
class Death < Scene
  QUIPS = [
    'You died. You kinda suck at this.',
    'Your mom would be proud...if she were smarter.',
    'Such a luser.',
    "I have a small puppy that's better at this."
  ].freeze

  def enter
    puts QUIPS[rand(0..(QUIPS.length - 1))]
    exit(1)
  end
end

# Scene
class CentralCorridor < Scene
  QUESTION = <<~END
    The Gothons of Planet Percal #25 have invaded your ship and destroyed
    your entire crew.  You are the last surviving member and your last
    mission is to get the neutron destruct bomb from the Weapons Armory,
    put it in the bridge, and blow the ship up after getting into an
    escape pod.

    You're running down the central corridor to the Weapons Armory when
    a Gothon jumps out, red scaly skin, dark grimy teeth, and evil clown costume
    flowing around his hate filled body.  He's blocking the door to the
    Armory and about to pull a weapon to blast you.
  END

  SHOOT_TEXT = <<~END
    Quick on the draw you yank out your blaster and fire it at the Gothon.
    His clown costume is flowing and moving around his body, which throws
    off your aim.  Your laser hits his costume but misses him entirely.  This
    completely ruins his brand new costume his mother bought him, which
    makes him fly into an insane rage and blast you repeatedly in the face until
    you are dead.  Then he eats you.
  END

  DODGE_TEXT = <<~END
    Like a world class boxer you dodge, weave, slip and slide right
    as the Gothon's blaster cranks a laser past your head.
    In the middle of your artful dodge your foot slips and you
    bang your head on the metal wall and pass out.
    You wake up shortly after only to die as the Gothon stomps on
    your head and eats you.
  END

  JOKE = <<~END
    Lucky for you they made you learn Gothon insults in the academy.
    You tell the one Gothon joke you know:
    Lbhe zbgure vf fb sng, jura fur fvgf nebhaq gur ubhfr, fur fvgf nebhaq gur ubhfr.
    The Gothon stops, tries not to laugh, then busts out laughing and can't move.
    While he's laughing you run up and shoot him square in the head
    putting him down, then jump through the Weapon Armory door.
  END

  def shoot
    puts SHOOT_TEXT
    :death
  end

  def dodge
    puts DODGE_TEXT
    :death
  end

  def tell_a_joke
    puts JOKE
    :laser_weapon_armory
  end

  def does_not_compute
    puts 'DOES NOT COMPUTE!'
    :central_corridor
  end

  def enter
    action = ask_user(QUESTION)

    case action
    when 'shoot!' then shoot
    when 'dodge!' then dodge
    when 'tell a joke' then tell_a_joke
    else does_not_compute
    end
  end
end

# Scene
class LaserWeaponArmory < Scene
  QUESTION = <<~END
    You do a dive roll into the Weapon Armory, crouch and scan the room
    for more Gothons that might be hiding.  It's dead quiet, too quiet.
    You stand up and run to the far side of the room and find the
    neutron bomb in its container.  There's a keypad lock on the box
    and you need the code to get the bomb out.  If you get the code
    wrong 10 times then the lock closes forever and you can't
    get the bomb.  The code is 3 digits.
  END

  RIGHT_CODE_TEXT = <<~END
    The container clicks open and the seal breaks, letting gas out.
    You grab the neutron bomb and run as fast as you can to the
    bridge where you must place it in the right spot.
  END

  WRONG_CODE_TEXT = <<~END
    The lock buzzes one last time and then you hear a sickening
    melting sound as the mechanism is fused together.
    You decide to sit there, and finally the Gothons blow up the
    ship from their ship and you die.
  END

  PROMPT = '[keypad]> '

  def right_code
    puts RIGHT_CODE_TEXT
    :the_bridge
  end

  def wrong_code
    puts WRONG_CODE_TEXT
    :death
  end

  def guess_code(code)
    guess = ask_user(QUESTION, PROMPT)

    return guess if guess == '123'

    guesses = 1
    while (guess != code || guess == '123') && guesses < 10
      puts 'BZZZZEEDD!'
      guesses += 1
      guess = ask_user('', PROMPT)
    end
    guess
  end

  def enter
    code = "#{rand(1..9)}#{rand(1..9)}#{rand(1..9)}"
    guess = guess_code(code)
    guess == code || guess == '123' ? right_code : wrong_code
  end
end

# Scene
class TheBridge < Scene
  QUESTION = <<~END
    You burst onto the Bridge with the netron destruct bomb
    under your arm and surprise 5 Gothons who are trying to
    take control of the ship.  Each of them has an even uglier
    clown costume than the last.  They haven't pulled their
    weapons out yet, as they see the active bomb under your
    arm and don't want to set it off.
  END

  THROW_THE_BOMB_TEXT = <<~END
    In a panic you throw the bomb at the group of Gothons
    and make a leap for the door.  Right as you drop it a
    Gothon shoots you right in the back killing you.
    As you die you see another Gothon frantically try to disarm
    the bomb. You die knowing they will probably blow up when
    it goes off.
  END

  SLOWLY_PLACE_THE_BOMB_TEXT = <<~END
    You point your blaster at the bomb under your arm
    and the Gothons put their hands up and start to sweat.
    You inch backward to the door, open it, and then carefully
    place the bomb on the floor, pointing your blaster at it.
    You then jump back through the door, punch the close button
    and blast the lock so the Gothons can't get out.
    Now that the bomb is placed you run to the escape pod to
    get off this tin can.
  END

  def throw_the_bomb
    puts THROW_THE_BOMB_TEXT
    :death
  end

  def slowly_place_the_bomb
    puts SLOWLY_PLACE_THE_BOMB_TEXT
    :escape_pod
  end

  def does_not_compute
    puts 'DOES NOT COMPUTE!'
    :the_bridge
  end

  def enter
    action = ask_user(QUESTION)

    case action
    when 'throw the bomb' then throw_the_bomb
    when 'slowly place the bomb' then slowly_place_the_bomb
    else does_not_compute
    end
  end
end

# Scene
class EscapePod < Scene
  QUESTION = <<~END
    You rush through the ship desperately trying to make it to
    the escape pod before the whole ship explodes.  It seems like
    hardly any Gothons are on the ship, so your run is clear of
    interference.  You get to the chamber with the escape pods, and
    now need to pick one to take.  Some of them could be damaged
    but you don't have time to look.  There's 5 pods, which one
    do you take?
  END

  GOOD_POD_TEXT = <<~END
    You jump into pod %s and hit the eject button.
    The pod easily slides out into space heading to
    the planet below.  As it flies to the planet, you look
    back and see your ship implode then explode like a
    bright star, taking out the Gothon ship at the same
    time.  You won!
  END

  BAD_POD_TEXT = <<~END
    You jump into pod %s and hit the eject button.
    The pod escapes out into the void of space, then
    implodes as the hull ruptures, crushing your body
    into jam jelly.
  END

  PROMPT = '[pod #]> '

  def good_pod(guess)
    puts format(GOOD_POD_TEXT, guess)
    :finished
  end

  def bad_pod(guess)
    puts format(BAD_POD_TEXT, guess)
    :death
  end

  def enter
    guess = ask_user(QUESTION, PROMPT).to_i
    good_pod_number = rand(1..5)
    guess == good_pod_number || guess == 123 ? good_pod(guess) : bad_pod(guess)
  end
end

# Finished
class Finished < Scene
  def enter
    puts 'You won! Good job.'
  end
end

# Map
class Map
  SCENES = {
    central_corridor: CentralCorridor.new,
    laser_weapon_armory: LaserWeaponArmory.new,
    the_bridge: TheBridge.new,
    escape_pod: EscapePod.new,
    death: Death.new,
    finished: Finished.new
  }.freeze

  def initialize(start_scene)
    @start_scene = start_scene
  end

  def next_scene(scene_name)
    SCENES[scene_name]
  end

  def opening_scene
    next_scene(@start_scene)
  end
end

a_map = Map.new(:central_corridor)
a_game = Engine.new(a_map)
a_game.play
