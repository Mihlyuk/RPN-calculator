require ('./calculator.rb')
require('colored')

loop do
  system 'clear'
  puts ('Input expression: ')

  calc = Calculator.new(gets.chomp)

  puts "\nCorrect expression : #{calc.expression.join(' ')}"

  notation = calc.notation
  col_spaces = 'Correct expression'.size - 'Result OPN'.size
  puts 'Result OPN' + ' ' * col_spaces + " : #{notation.join(' ')}"

  result = calc.result
  col_spaces = 'Correct expression'.size - 'Result'.size
  puts ('Result' + ' ' * col_spaces + " : #{result}\n\n").red.bold

  puts 'press any key...'
  gets

end
