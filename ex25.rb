# Modulo referente ao exercicio 25
module Ex25
  module_function

  # This function will break up words for us.
  def break_words(stuff)
    stuff.split(' ')
  end

  # Sorts the words.
  def sort_words(words)
    words.sort
  end

  # Prints the first word after shifting it off.
  def print_first_word(words)
    puts words.shift
  end

  # Prints the last word after poping it off.
  def print_last_word(words)
    puts words.pop
  end

  # Takes in a full sentence and returns the sorted words.
  def sort_sentence(sentence)
    words = break_words(sentence)
    sort_words(words)
  end

  # Prints the first and last words of the sentence.
  def print_first_and_last(sentence)
    words = break_words(sentence)
    print_first_word(words)
    print_last_word(words)
  end

  # Sorts the words then prints the first and last one.
  def print_first_and_last_sorted(sentence)
    words = sort_sentence(sentence)
    print_first_word(words)
    print_last_word(words)
  end
end
