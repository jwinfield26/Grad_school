##################################################################################
# Justin Winfield
# Monday, October 8th
# I have not given or received any unauthorized assistance on this assignment
##################################################################################

def throwPairDice():
    "Throwing a pair of dice"
    import random
    throw = random.randrange(1,7) + random.randrange(1,7) # Simulates rolling of a pair of dice
    return throw

def throwThirdDice():
    "Throwing an extra dice if User wants to double their bet if they lost on the first throw"
    import random
    thirdThrow = random.randrange(1,7) # Simulates the third dice
    return thirdThrow

# Main Game

account = 100
while True:

    bet = eval(input("Place your bet: "))

    if bet <= account and bet > 0:
        firstRoll = throwPairDice()
        if firstRoll in (7,12): # Check to see if the User rolls a 7 or a 12
            winnings = 2*bet
            newAccount = account + winnings # Double the user's total bet
            print("You rolled a {}. You Win! Wininngs: {}, New Account Balance: {}".format(firstRoll, winnings, newAccount))
            account = newAccount
        else:
            print("You rolled a {}".format(firstRoll))
            retry = eval(input("Want to try again? [1] - Yes, [2] - No: "))
            if retry == 2:
                newAccount = account - bet
                print("You rolled a {}. You Lose! New Account Balance: {}".format(firstRoll, newAccount))
                account = newAccount
            if retry == 1:
                doubleBet = bet * 2
                if doubleBet >= account: # Don't have enough money to play
                    newAccount = account - bet
                    print("You do not have the sufficient funds to play. You lose! New Account Balance: {}".format(newAccount))
                    account = newAccount
                else:
                    newRoll = throwThirdDice()
                    combined = firstRoll + newRoll
                    if combined in (7,12): # Triple their total bet
                        winnings = 3 * doubleBet
                        newAccount = account + winnings
                        print("You rolled a {}. You Win! Wininngs: {}, New Account Balance: {}".format(combined, winnings, newAccount))
                        account = newAccount
                    else:
                        newAccount = account - doubleBet
                        print("You rolled a {}. You Lose! New Account Balance: {}".format(combined, newAccount))
                        account = newAccount

    else: # if the user has no 'money' to play
        print("You do not have the sufficient funds to play. You lose! New Account Balance: {}".format(account))
        account = newAccount