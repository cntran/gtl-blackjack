deck = { "clubs" => ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'],
	       "diamonds" => ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'],
         "hearts" => ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'],
         "spades" => ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']}



dealer_cards = []
player_cards = []

def deal_card deck

  suit_index = ["clubs", "diamonds", "hearts", "spades"]

  # select card from deck at random
  random_suit = suit_index[rand(4)]
  random_card_index = rand(deck[random_suit].length)
  dealt_card = { "suit" => random_suit, "value" => deck[random_suit][random_card_index] }
	
  # remove card from deck
  deck[random_suit].delete_at(random_card_index)

  dealt_card_and_deck = { "dealt_card" => dealt_card, "deck" => deck }
		
  return dealt_card_and_deck

end

def card_count cards 

	card_values = {"2" => 2, "3" => 3, "4" => 4, "5" => 5, 
	           		 "6" => 6, "7" => 7, "8" => 8, "9" => 9, 
	               "10" => 10, "J" => 10, "Q" => 10, "K" => 10}

	count = 0
	aces_count = 0
	# count non - Aces
  cards.each do |i|
  	if i["value"] != "A" 
  		count = count + card_values[i["value"]]
  	else
  		aces_count = aces_count + 1
  	end 
  end

  # count Aces (maximize total without going over 21)
  if aces_count > 0
	  max_aces_value = 0
	  min_aces_value = 0

	 	for i in 0..aces_count - 1
	  	min_aces_value = min_aces_value + 1
	  end

	  max_aces_value = min_aces_value + 10

	  if (count + max_aces_value) > 21
	  	count = count + min_aces_value
	  else
	  	count = count + max_aces_value
	  end
	end

  return count
end

def display_hand cards
	cards.each do |i|
 	 print i["value"] + ' of ' + i["suit"] + ', '
	end
	puts "(" + card_count(cards).to_s + ")"
end

# Initial deal of cards to player and dealer (2 cards to each person):
for i in 0..1
  # deal a card to player
  dealt_card_and_deck = deal_card( deck )
  deck = dealt_card_and_deck["deck"]
  dealt_card = dealt_card_and_deck["dealt_card"]

  player_cards.push(dealt_card)

  # deal a card to dealer
  dealt_card_and_deck = deal_card( deck )
  deck = dealt_card_and_deck["deck"]
  dealt_card = dealt_card_and_deck["dealt_card"]

  dealer_cards.push(dealt_card)
end

display_hand(player_cards)

#dealer_cards.each do |i|
#  puts i["value"] + ' of ' + i["suit"]
#end
#puts card_count(dealer_cards)


# Allow player to get more cards:
begin
	puts "Hit or stay? 1) hit 2) stay"
	reply = gets.chomp
	if reply == "1"
		dealt_card_and_deck = deal_card( deck )
  	deck = dealt_card_and_deck["deck"]
  	dealt_card = dealt_card_and_deck["dealt_card"]

  	player_cards.push(dealt_card)
  	display_hand(player_cards)
	end
end while card_count(player_cards) < 22 && reply == "1"


if (card_count(player_cards) > 21)
	puts "Oh no! You busted! You lose!"
else
	#dealer's move
	while card_count(dealer_cards) < 17
		dealt_card_and_deck = deal_card( deck )
  	deck = dealt_card_and_deck["deck"]
  	dealt_card = dealt_card_and_deck["dealt_card"]

  	dealer_cards.push(dealt_card)
	end

	display_hand(dealer_cards)
	if card_count(dealer_cards) > 21
		puts "Dealer busted! You win!"
	elsif card_count(dealer_cards) > card_count(player_cards)
		puts "Sorry, dealer wins. Try again."
	elsif card_count(dealer_cards) < card_count(player_cards)
		puts "You win!"
	else
		puts "You push."
	end

end

