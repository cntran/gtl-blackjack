require 'pry'

# BlackJack OOP
# Requirements 
# 1. A deck of 52 cards
# 2. Minimum of two players one of which is the dealer
# 3. Be able to deal card(s) from deck to players
# 4. Be able to shuffle the deck of cards to randomize order of cards
# 5. Count the value of a player's hand
# 6. Compare value of player's hand against the dealer's to determine outcome

# Nouns: [card, deck, player, dealer, blackjack]
# Verbs: [deal, shuffle, count, compare]

class Card

  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    puts suit + ', ' + value
  end

end

class Deck

  attr_accessor :cards

  def initialize()
    @cards = []
    suits = ['C', 'D', 'H', 'S']
    cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

    deck = suits.product(cards)
    deck.each do |card|
      @cards.push(Card.new(card[0], card[1]))
    end

  end

  def shuffle
    cards.shuffle!
  end

  def deal
    cards.pop
  end

  def to_s
    cards.each do |card|
      puts card.suit + ' ' + card.value + ', '
    end
  end

end


class Player

  attr_accessor :name, :cards

  def initialize(name)
    @name = name
    @cards = []
  end

  def add_card(card)
    cards.push(card)
  end

  def show_cards
    print name 
    print " cards: [ "
    cards.each do |card|
      print "#{card.value} "
    end
    puts "]"
  end

end

class BlackJackDealer < Player

  def initialize(name)
    super
  end

  def show_hole_card
     puts  name + " cards: [ * #{cards[1].value} ]"
  end

end

#Game Engine
class BlackJack

  attr_accessor :deck, :player, :dealer

  def initialize
    
    @player = Player.new("")
    @dealer = BlackJackDealer.new("Dealer")
    # Set new deck, shuffle
    @deck = Deck.new
    deck.shuffle

  end

  def initialize_player
    puts "What's your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
    player.add_card(deck.deal)
    dealer.add_card(deck.deal)
  end

  def get_hand_value(cards)

    hand_value = 0

    card_values = cards.map{ |a| a.value }
    aces_count = 0
    card_values.each do |value|

      if value == 'A'
        hand_value += 11
        aces_count += 1
      elsif value.to_i == 0 # non numeric value cards
        hand_value += 10
      else
        hand_value += value.to_i
      end

    end

    # Check for busts relating to Aces being counted at 11
    while aces_count > 0
      if hand_value > 21
        hand_value -= 10
      end
      aces_count -= 1
    end

    return hand_value

  end

  def blackjack?(card_value)
    card_value == 21 ? true : false
  end

  def busted?(card_value)
    card_value > 21 ? true : false
  end

  def run
    puts "Welcome to Blackjack."
    initialize_player

    begin 
      puts ""
      player.cards = []
      dealer.cards = []
      deal_cards

      player.show_cards
      dealer.show_hole_card

      player_total = get_hand_value(player.cards)
      dealer_total = get_hand_value(dealer.cards)

      puts "Your hand value: #{player_total}"

      if blackjack?(player_total)
        puts "You got blackjack! You win!"
      else

        while player_total < 21

          puts "Do you wish to 1) hit or 2) stay?"
          hit_or_stay = gets.chomp

          if hit_or_stay.to_i == 1
            player.add_card(deck.deal)
            player.show_cards
            player_total = get_hand_value(player.cards)
            puts "Your hand value: #{player_total}"
          elsif hit_or_stay.to_i == 2
            break
          end

        end

        if busted?(player_total)
          puts "You busted! You lose!"
        else
          
          dealer.show_cards
          puts "Dealer hand value: #{dealer_total}"
          if blackjack?(dealer_total)
            puts "Dealer got blackjack! You lose!"
          else

            if dealer_total < 17
              while dealer_total < 17
                dealer.add_card(deck.deal)
                dealer_total = get_hand_value(dealer.cards)
              end

              dealer.show_cards
              puts "Dealer final hand value: #{dealer_total}"
            end

          
            if dealer_total > 21 

              puts "Dealer busted! You win!"
            elsif dealer_total == player_total
              puts "You and Dealer push."
            elsif dealer_total < player_total
              puts "You win with a higher hand!"
            elsif dealer_total > player_total
              puts "You lose! Dealer wins with a higher hand."
            end

          end

        end


      end

      puts "Do you want to play again? 1) yes"
      play_again = gets.chomp

    end while play_again.to_i == 1


  end

end


blackjack = BlackJack.new
blackjack.run















