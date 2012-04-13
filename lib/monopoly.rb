class Dice
  attr_accessor :type, :value, :turn, :players, :doubles
  def initialize(number)
    @type = :new
    @turn = rand(number)
    @players = number
    @doubles = 0
  end
  
  def roll_em
    die1 = rand(6) + 1
    die2 = rand(6) + 1
    return die1, die2
  end
  
  def roll_dice(player)
    die1, die2 = roll_em
    roll = die1 + die2
    if die1 == die2
      @doubles += 1
      if @doubles < 3
        puts "Doubles are rolled !! @doubles = #{@doubles}"
      else
        puts "Third doubles in a row ... GO TO JAIL! @doubles = #{@doubles}"
        @doubles = 0
        player.jail = true
        player.turns_in_jail = 0
        player.square = 10
      end
    else
      @doubles = 0
    end
    return roll
  end

  def next_turn
    @doubles = 0
    @turn   += 1
    if @turn == @players
      @turn  = 0
    end
    return @turn
  end
end

class Property
  attr_accessor :owner, :monopolized, :mortgaged, :build, :rent, :landed_on, :income
  attr_reader   :name,  :color, :cost, :house_price, :base_rent, :house1_rent, :house2_rent, :house3_rent, :house4_rent, :hotel_rent
  def initialize(name, color, cost, house_price, rent, house2, house3, house4, hotel, house1=nil)
    @name   = name
    @color  = color
    @owner  = nil            # nil or player object - variable
    @monopolized = false     # variable
    @cost        = cost
    @mortgaged   = false     # variable
    @house_price = cost/2
    @build       = 0         # variable
    @base_rent   = rent
    @house1_rent = house1 || rent*5
    @house2_rent = house2
    @house3_rent = house3
    @house4_rent = house4
    @hotel_rent  = hotel
    @rent        = rent       # variable
    @landed_on   = 0          # variable
    @income      = 0          # variable
  end
end

class Corner
  attr_reader :type, :name
  def initialize(type)
    @type = type
    @name = type.capitalize
  end
end

class CardLocation
  attr_reader  :type, :value, :text, :name
  def initialize(type, value=nil, text=nil)
    @type  = type
    @value = value
    @text  = text
    @name = type.capitalize
  end
end

class Utility
  attr_accessor  :monopolized, :owner, :mortgaged, :landed_on, :income
  attr_reader    :cost, :name
  def initialize(name)
    @monopolized = false            # variable
    @cost        = 150
    @owner       = nil              # variable
    @name        = name
    @mortgaged   = false            # variable
    @landed_on   = 0                # variable
    @income      = 0                # variable
  end
end

class Railroad
  attr_accessor  :owner, :rent, :multiplier, :landed_on, :income, :mortgaged
  attr_reader    :base_rent, :name, :cost
  def initialize(name)
    @name        = name
    @cost        = 200
    @owner       = nil                   # variable
    @base_rent   = 25
    @rent        = 25                    # variable based on number of owner railroads
    @multiplier  = 1                     # variable based on number of owner railroads
    @landed_on   = 0                     # variable
    @income      = 0                     # variable
    @mortgaged   = false                 # variable
  end
end

class Player 
  attr_accessor :money, :square, :houses, :hotels, :jail, :gooj, :turns_in_jail, :assets
  attr_reader   :id,    :name
  def initialize(cash, number)
    puts "Player #{number} what is your name ?"
    print " -> "
    name = gets.chomp.downcase                        # players now can have the same name , kinda confusing
    # name = "Player #{number}"
    @id     = number   
    @name   = name.capitalize
    @money  = cash    # variable
    @square = 0       # variable
    @houses = 0       # variable
    @hotels = 0       # variable
    @jail   = false   # variable
    @gooj   = 0       # variable
    @turns_in_jail = 0 #variable
    @assets = []      # variable
  end
  
  def move(player, roll)
    @square += roll
    if @square >= 40
      @square      -= 40
      player.money += 200
      puts "Salary via .move -> collect $200"
    end
  end
  
  def goto(player, new_square)
    old_square = @square
    @square    = new_square
    if old_square > @square
      puts "Salary via .goto -> collect $200"
      player.money += 200
    end
  end
end

class Monopoly
  attr_accessor  :number_players, :start_cash, :players, :chest, :chance

  def initialize
    print "\e[2J\e[f"
    @board = nil
  end

  def game_board
      board = []
      board[0] = Corner.new('go')
      board[1] = Property.new('Mediterranean', 'brown', 60, 50, 2, 30,  90, 160, 250)
      board[2] = CardLocation.new('chest')
      board[3] = Property.new('Baltic',        'brown', 60, 50, 4, 60, 180, 320, 450)
      board[4] = CardLocation.new('tax', 200, 'Income Tax')
      board[5] = Railroad.new('Reading Railroad')
      board[6] = Property.new('Oriental',      'baby', 100, 50, 6, 90, 270, 400, 550)
      board[7] = CardLocation.new('chance')
      board[8] = Property.new('Vermont',       'baby', 100, 50, 6, 90, 270, 400, 550)
      board[9] = Property.new('Connecticut',   'baby', 120, 50, 8,100, 300, 450, 600)
      board[10]= Corner.new('jail/just visiting')
      board[11]= Property.new('St Charles',  'purple', 140,100,10,150, 450,625,750)
      board[12]= Utility.new('Electric Company')
      board[13]= Property.new('States' ,     'purple', 140,100,10,150, 450,625,750)
      board[14]= Property.new('Virginia',    'purple', 160,100,12,180, 500,700,900)
      board[15]= Railroad.new('Pennsylvania Railroad')
      board[16]= Property.new('St. James',   'orange', 180,100,14,200, 550,750,950)
      board[17]= CardLocation.new('chest')
      board[18]= Property.new('Tenneessee',  'orange', 180,100,14,200, 550,750,950)
      board[19]= Property.new('New York',    'orange', 200,100,16,220, 600,800,100)
      board[20]= Corner.new('freeparking')
      board[21]= Property.new('Kentucky',       'red', 220,150,18,250, 700, 875,1050)
      board[22]= CardLocation.new('chance')
      board[23]= Property.new('Indiana',        'red', 220,150,18,250, 700, 875,1050)
      board[24]= Property.new('Illinois',       'red', 240,150,20,300, 750, 925,1100)
      board[25]= Railroad.new('B & O Railroad')
      board[26]= Property.new('Atlantic',    'yellow', 260,150,22,330,800,975,1150)
      board[27]= Property.new('Vetnor',      'yellow', 260,150,22,330,800,975,1150)
      board[28]= Utility.new('Water Works')
      board[29]= Property.new('Marvin Gardens','yellow', 280, 150, 24, 360, 850, 1025, 1200)
      board[30]= Corner.new('gotojail')
      board[31]= Property.new('Pacific',      'green', 300,200,26,390, 900,1100,1275)
      board[32]= Property.new('No Carolina',  'green', 300,200,26,390, 900,1100,1275)
      board[33]= CardLocation.new('chest')
      board[34]= Property.new('Pennsylvania', 'green', 320,200,28,450,1000,1200,1400,150)
      board[35]= Railroad.new('Short Line Railroad')
      board[36]= CardLocation.new('chance')
      board[37]= Property.new('Park Place',    'blue', 350,200,35,500,1100,1300,1500)
      board[38]= CardLocation.new('tax', 100,  'Luxury Tax')
      board[39]= Property.new('Boardwalk',     'blue', 400, 200, 50, 600, 1400, 1700, 2000, 200)
      return board
  end

  def launch!
    puts "Welcome to Monopoly!"
    options
    @players = []
    @number_players.times do |i|
      x = i + 1
      @players << Player.new(@start_cash, x)
    end
    @board  = game_board
    @chance = shuffle_chance
    @chest  = shuffle_chest
    game    = Dice.new(@number_players)
    game_on = true                              #################################   play_game
    while game_on                              ################# ROLL LOOP  START
      player_index = game.turn
      player   = @players[player_index]
      begin_turn(player,game)
      
      if !player.jail || game.doubles > 0
        game_on  = end_turn(game_on)
      end
      if game.doubles == 0 || player.jail
        game.next_turn
      else
        puts "ROLL AGAIN!"
      end
      
      #  end turn 
      
    end                               ####################  ROLL LOOP END
  end

  def begin_turn(player,game)
    answers = ['r', 'm']
    puts "#{player.name}'s turn. You have -> $#{player.money}"
    puts "You can Roll , Trade , Manage , Log, Pause "
    user = get_y_n(answers)
    case user
    when 'r'
      roll(player, game)
    when 't'
      puts "trade method needs to be written"
    when 'm'
      manage(player, game)
    when 'l'
      puts "log method needs to be written"
    when 'p'
      puts "pause method needs to be written"
    end
  end

  def roll(player, game)
    if player.jail
      roll     = in_jail(player, game)
    else
      roll     = game.roll_dice(player)
      location = walk(player, roll)
      action(player, location, roll)
    end
  end

  def manage(player, game)
    i = 01
    answers = ['b']
    assets  = []
    @board.each do |location|
      case location.class.to_s
      when "Property", "Railroad", "Utility"
        owner = ""
        owner = " -  #{location.owner.name}" if location.owner
        msg =  "#{i}  : #{location.name} - #{location.cost}"
        puts msg << owner
        answers << i.to_s
        assets  << location
        i += 1
      end
    end
    puts " type a number to see detail on any property or 'b'ack "
    user = get_y_n(answers)
    if user == 'b'
      begin_turn(player, game)
    else
      user = user.to_i - 1
      location = assets[user]
      detail_asset(location, player, game)
    end
  end
  
  def detail_asset(location, player, game)
    case location.class.to_s
    when "Property"
      detail_property(location)
    when "Railroad"
      detail_railroad(location)
    when "Utility"
      detail_utility(location)
    end
    option_bar(location, player, game)
  end
  
  def option_bar(location, player, game)
    answers = ['b']
    msg = " type 'b'ack "
    if location.owner == player
      if location.mortgaged 
        answers << 'u'
        msg << " or 'u'nmortgage"
      else
        answers << 'm'
        msg << " or 'm'ortgage"
      end
    end
    puts msg
    user = get_y_n(answers)
    case user
    when 'u'
      amount = location.cost * 0.55
      player.money -= amount
      location.mortgaged = false
    when 'm'
      amount = location.cost / 2
      player.money += amount
      location.mortgaged = true
    end
    manage(player, game)
  end
  
  def detail_railroad(location)
    puts "Manage Property"
    puts location.name
    puts "Mortgaged." if location.mortgaged
    puts "RENT                   $25"
    puts "If 2 Stations Owned    $50"
    puts "If 3 Stations Owned   $100"
    puts "If 4 Stations Owned   $200"
    puts "Mortgage Value  $100"
    stats(location)
  end
  
  def detail_utility(location)
    puts "Manage Property"
    puts location.name
    puts "Mortgaged." if location.mortgaged
    puts "If one Utility is owned, rent"
    puts "   is 4 times the amount "
    puts "      shown on dice."
    puts "If both Utilities are owned, "
    puts " rent is 10 times the amount "
    puts "      shown on dice."
    puts "Mortgage Value  $75"
    stats(location)
  end
  
  def detail_property(location)
    puts "Manage Property"
    puts location.name
    puts location.color
    puts "Mortgaged." if location.mortgaged
    puts "Rent   #{location.base_rent}"
    puts "With 1 House   #{location.house1_rent}"
    puts "With 2 Houses  #{location.house2_rent}"
    puts "With 3 Houses  #{location.house3_rent}"
    puts "With 4 Houses  #{location.house4_rent}"
    puts "With HOTEL     #{location.hotel_rent}"
    mortgage = location.cost / 2
    puts "Mortgage Value #{mortgage}"
    puts "Houses cost $$$ each"
    puts "Hotels, $$$$ each plus 4 houses"
    stats(location)
  end
  
  def stats(location)
    location_owner(location)
    case location.landed_on
    when 0
      puts "Never landed on"
    when 1
      s = 's'
      stats_long(location, s)
    else
      s = ""
      stats_long(location, s)
    end
  end
  
  def stats_long(location, s)
    word = "time#{s}"
    puts "Landed on #{location.landed_on} #{word}"
    puts "Current rent : $#{location.rent}"
    puts "Income : $#{location.income}"
  end
  
  def location_owner(location)
    if location.owner
      puts "Owned by : " + location.owner.name
    else
      puts "Unowned"
    end
  end
  
  def end_turn(game_on)
    puts " End Turn ?"
    answers  = ['y', 'q']
    user = get_y_n(answers)
    if user == 'q'
      game_on = false
    end
    return game_on
  end

  def get_y_n(answers)
    action = nil
    until answers.include?(action)
      puts "Actions: " + answers.join(', ') if action
      print " -> "
      user_response = gets.chomp.downcase  
      action = user_response
    end
    return action
  end
  
  def walk(player, roll)
    puts "#{player.name} has rolled #{roll}"
    player.move(player, roll)
    location = @board[player.square]
    return location
  end
  
  def in_jail(player, game)
    answers = ['y','p']
    if player.gooj > 0
      puts "#{player.name} is in JAIL - you must roll doubles to get out or post bail for $50 or use Get out of Jail Free Card"
      puts "type 'y' to roll / 'p' to post bail / 'c' to use your get out of jail free card"
      answers << 'c'
    else
      puts "#{player.name} is in JAIL - you must roll doubles to get out or post bail for $50"
      puts "type 'y' to roll / 'p' to post bail"
    end
    user = get_y_n(answers)
    case user
    when 'y'
      roll = game.roll_dice(player)
      if game.doubles == 1
        puts "you've rolled your way out of JAIL ! Congrats"
        player.jail   = false
        game.doubles  = 0
      else
        if player.turns_in_jail == 2
          puts "#{player.name} did not roll doubles - you must post bail for $50"
          player.money -= 50
          player.jail   = false
          puts "You have posted bail."
        else
          puts "No doubles rolled, stay in Jail."
          player.turns_in_jail += 1
        end
      end
    when 'p'
      player.money -= 50
      player.jail   = false
      puts "You have posted bail."
      roll = game.roll_dice(player)
    when 'c'
      player.gooj  -= 1
      player.jail   = false
      puts "You've used Get Out of Jail Free Card"
      roll = game.roll_dice(player)
    end
    return roll
  end
  
  def options
    puts "How many players?"
    answers = ['2', '3', '4']
    # @number_players = get_y_n(answers).to_i
    @number_players = 2
    puts "ok .. #{@number_players} players"
    puts "How much starting cash ?"
    puts " 1000 , 1500, or 2000 each ?"
    answers = ['1000','1500','2000']
    # @start_cash = get_y_n(answers).to_i
    @start_cash = 1000
    puts "ok ... $#{@start_cash} for each player to start "
  end

  def shuffle_chance
    chance_cards = [[:simple,"Advance to Go (Collect $200)", 0],
     [:simple,"Advance to Illinois Ave - if you pass Go, collect $200", 24],
     [:utility,"Advance token to nearest Utility. If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total ten times the amount thrown."],
     [:rail,"Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled. If Railroad is unowned, you may buy it from the Bank."],
     [:simple, "Advance to St Charles Place - if you pass GO. collect $200",11],
     [:income,"Bank pays you dividend of $50",50],
     [:out_jail,"Get out of Jail Free - this cards may be kept until needed, or traded/sold"],
     [:back ,"Go back 3 spaces"],
     [:jail ,"Go directly to Jail - do not pass Go, do not collect $200",10],
     [:repair ,"Make general repairs on all your property - for each house pay $25 - for each hotel $100",[25,100]],
     [:tax ,"Pay poor tax of $15",-15],
     [:simple ,"Take a trip to Reading Railroad - if you pass Go, collect $200",5],
     [:simple ,"Take a walk on the Boardwalk - advance token to Boardwalk",39],
     [:paid ,"You have been elected chairman of the board - pay each player $50",-50],
     [:income ,"Your building loan matures - collect $150",150],
     [:income ,"You have won a crossword competition - collect $100",100]]
    cards = shuffler(chance_cards)
    puts "shuffled chance!"
    return cards
  end

  def shuffle_chest
    chest_cards = [[:simple,"Advance to Go (Collect $200)",0],
     [:income,"Bank error in your favor - collect $200",200],
     [:tax,"Doctor's fees - Pay $50",-50],
     [:out_jail,"Get Out of Jail Free - this card may be kept until needed, or sold"],
     [:jail,"Go to jail - go directly to jail - Do not pass Go, do not collect $200",10],
     [:paid,"It is your birthday - Collect $10 from each player",10],
     [:income,"Income Tax refund - collect $20",20],
     [:income,"Life Insurance Matures - collect $100",100],
     [:tax,"Pay Hospital Fees of $100",-100],
     [:tax,"Pay School Fees of $50",-50],
     [:income,"Receive $25 Consultancy Fee",25],
     [:repair,"You are assessed for street repairs - $40 per house, $115 per hotel",[40,115]],
     [:income,"You have won second prize in a beauty contest - collect $10",10],
     [:income,"You inherit $100",100],
     [:income,"From sale of stock you get $50",50],
     [:income,"Holiday Fund matures - Receive $100",100]]
     cards = shuffler(chest_cards)
     puts "shuffled chest!"
     return cards
  end

  def shuffler(cards)
    shuffled = []
     num = cards.count
     until num == 0
        choice = rand(num)
        shuffled << cards.slice!(choice)
        num = cards.count
     end
    return shuffled
  end
  
  def buy_or_rent(player, location, roll, card=false)
    location.landed_on += 1
    if location.owner.nil?
      buy(player, location)
    else
      who_owner(player, location, roll, card)
    end
  end
  
  def buy(player, location)
    puts "#{location.name} is unowned" 
    puts "Price is -> $#{location.cost}"
    puts " .. would you like to buy it ? ('y' to buy , 'n' to pass) "
    answers = ['y','n']
    user = get_y_n(answers)
    if user == 'y'
      puts " You have bought #{location.name}. Price is #{location.cost}"
      player.money  -= location.cost
      location.owner = player
      player.assets  << location
      calculate_rent(location)
    else
      puts " You have passed on #{location.name}"
    end
  end
  
  def calculate_rent(location)
    case location.class.to_s
    when "Property"
      color = location.color
      group_array = []
      group = true
      @board.each do |b|
        if b.class.to_s == "Property" 
          if b.color == color
            if b.owner == location.owner
              group = group && true
              group_array << b
            else
              group = false
            end
          end
        end
      end
      if group 
        puts "The #{color} property group is monopolized!"
        group_array.each do |g|
          g.monopolized = true
          g.rent = g.base_rent * 2
        end
      end
    when "Railroad"
      x         = [1,1,2,4,8]
      railroads = [@board[5],@board[15],@board[25],@board[35]]
      index     = 0
      railroads.each do |r|
        index  += 1 if r.owner == location.owner
      end
      puts "Railroads are monopolized!" if index == 4
      railroads.each do |r|
        if r.owner    == location.owner
          r.multiplier = x[index]
          r.rent = 25 * x[index]
        end
      end
    when "Utility"
      efactory   = @board[12]
      waterworks = @board[28]
      if efactory.owner == waterworks.owner
        efactory.monopolized   = true
        waterworks.monopolized = true
        puts "Utilities are monopolized!"
      end
    end
  end
  
  def who_owner(player, location, roll, card)
    if (location.owner == player) || location.mortgaged
      # puts "You own this location or its mortgaged"
    else
      if location.class.to_s == "Utility"
        pay_utility(player, location, roll)
      else
        pay_rent(player, location, card)
      end
    end
  end
  
  def pay_utility(player, location, roll, card=false)
    owner = location.owner
    if location.monopolized || card
      multiplier = 10
    else
      multiplier = 4
    end
    rent = roll * multiplier
    player.money    -= rent
    owner.money     += rent
    location.income += rent
    puts "#{player.name} has paid $#{rent} to #{owner.name}"
  end
  
  def pay_rent(player, location, card)
    owner = location.owner
    rent  = location.rent
    rent += rent if card
    player.money    -= rent
    owner.money     += rent
    location.income += rent
    puts "#{player.name} has paid $#{rent} to #{owner.name}"
  end
  
  def action(player, location, roll=nil)
    case location.class.to_s
    when "Property", "Railroad", "Utility"
      puts "#{player.name} moves to ->  #{location.name}"
      buy_or_rent(player, location, roll)
    when "CardLocation"
      card = get_card(location)
      p location.type
      puts card[1]
      execute_card(player, card)
    when "Corner"
      puts " Square is #{location.type.capitalize}"
      case_corner(player)
    else
      puts "we have a location class unknown #{location.type}"
    end
  end

  def get_card(location)
    case location.type
    when "chance"
      @chance = shuffle_chance if @chance.count == 0
      card    = @chance.pop
    when "chest"
      @chest  = shuffle_chest  if @chest.count  == 0
      card    = @chest.pop
    when "tax"
      card    = [:tax, location.text, -(location.value)]
    end
    return card
  end
  
  def execute_card(player, card)
    type = card[0]
    case type
    when :simple
      player.goto(player, card[2])
      location = @board[card[2]]
      action(player, location)
    when :tax
      player.money += card[2]
    when :income
      player.money += card[2]
    when :jail
      go_to_jail(player)
    when :out_jail
      player.gooj  += 1
    when :paid
      all_players_trade_money(player, card[2])
    when :utility
      go_to_utility(player)
    when :rail
      choose_railroad(player)
      location = @board[player.square]
      roll = nil
      card = true
      buy_or_rent(player, location, roll, card)
    when :back
      player.square -= 3
      location = @board[player.square]
      action(player, location)
    when :repair
      do_repairs(player, card)
    else
      puts "we have a CardLocation type unknown #{card.inspect}"
    end
  end
  
  def all_players_trade_money(player, amount)
    num = 0
    other_players = []
    @players.each do |p|
      if p.id != player.id
        other_players << p
      end
    end
    other_players.each do |p|
      p.money = p.money - amount
      num    += amount
      puts "#{p.name} has ->  $#{p.money} (all_players)"
    end
    player.money   += num
  end
  
  def go_to_utility(player)
    if (player.square >= 12) && (player.square < 28)
      player.goto(player, 28)
    else
      player.goto(player, 12)
    end
    location = @board[player.square]
    location.landed_on += 1
    if location.owner == nil
       puts "#{player.name} moves to ->  #{location.name}"
       buy(player, location)
    else
      if location.owner == player
        # nothing happens
      else
        puts "#{player.name} must roll for the card and utility rent ... ready ? 'y'"
        answer = ['y']
        user = get_y_n(answer)
        die1, die2 = Dice.new(1).roll_em
        roll = die1 + die2
        puts "#{player.name} rolls #{roll}"
        pay_utility(player, location, roll, true)
      end
    end
  end
  
  def do_repairs(player, card)
    house = player.houses
    hotel = player.hotels
    house_cost = house * card[2][0]
    hotel_cost = hotel * card[2][1]
    repairs = house_cost + hotel_cost
    if repairs > 0
      player.money -= repairs
      puts "#{player.name} is charged $#{repairs} for repairs."
    else
      puts "#{player.name} has no houses or hotels, repair fee is 0"
    end
  end
  
  def choose_railroad(player)
    case player.square
    when 5..14
      player.goto(player, 15)
    when 15..24
      player.goto(player, 25)
    when 25..34
      player.goto(player, 35)
    else
      player.goto(player, 5)
    end
  end
  
  def go_to_jail(player)
    player.square =  10
    player.jail   = true
    player.turns_in_jail = 0
    puts "#{player.name} moves to ->  JAIL"
  end
  
  def case_corner(player)
    if player.square == 30
      go_to_jail(player)
    end
  end
  
end