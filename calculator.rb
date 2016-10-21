class Calculator

  attr_accessor :expression, :notation, :result

  def initialize (expression)
    @expression = prepare_expression_array(expression)
    @notation = to_opn
    @result = calculate_result
  end

  def to_opn
    result = []
    stack = []

    @expression.each do |literal|
      case (literal_type(literal))
        when 'number' then
          result << literal
        when 'operation' then
          if stack.size === 0 || is_stack_priority_less(stack, literal)
            stack << literal
          elsif priority(stack.last) >= priority(literal)
            until stack.size == 0 || priority(stack.last) < priority(literal)
              result << stack.pop
            end

            if stack.size === 0 || is_stack_priority_less(stack, literal)
              stack << literal
            end

          end

        when 'opening_brace' then
          stack << literal

        when 'closing_brace' then
          until stack.last == '('
            result << stack.pop
          end

          stack.pop
      end
    end

    until stack.size === 0
      result << stack.pop
    end

    return result
  end

  def calculate_result
    result = []

    @notation.each do |literal|
      case (literal_type(literal))
        when 'number'
          result << literal
        when 'operation'
          op2= result.pop
          op1 = result.pop

          result << operation(literal, op1.to_i, op2.to_i)
      end
    end

    @result = result.pop
  end

  def operation(operation, op1, op2)
    case (operation)
      when '+' then op1 + op2
      when '-' then op1 - op2
      when '/' then op1 / op2
      when '*' then op1 * op2
      when '!' then calculate_factorial(op1, op2)
    end
  end

  def calculate_factorial(operator, degree)
    char_array = operator.to_s(2).chars
    array_size = char_array.size
    begin_bit = array_size > degree ? array_size - degree : 0
    end_bit = char_array.size

    begin_bit.upto(end_bit) { |number| char_array[number] = 0 }

    return char_array.join.to_i(2)
  end

  def is_stack_priority_less (stack, operation)
    stack.reverse_each do |elem|
      if elem === '('
        return true
      end

      unless priority(elem) < priority(operation)
        return false
      end
    end

    return true
  end

  def is_stack_priority_more (stack, operation)
    priority(operation) >= priority(stack.last)
  end

  def literal_type (literal)
    case (literal)
      when /\d+/ then 'number'
      when /[\+\-\/\*\!]/ then 'operation'
      when /[\(]/ then 'opening_brace'
      when /[\)]/ then 'closing_brace'

      else abort 'I don\'t know these characters!'
    end

  end

  def priority (sign)
    case (sign)
      when '(' then 1
      when '-' then 2
      when '+' then 2
      when '/' then 3
      when '*' then 3
      when '!' then 4

      else abort 'I don\'t know these operation!'
    end

  end

  def prepare_expression_array (expression)
    correct_expression = correct_expression (expression)

    expression_array = []
    correct_expression.gsub(/[\+\-\/\*\(\)\!]|\d+\.?\d*/) { |reg| expression_array << reg }

    return expression_array
  end


  def correct_expression (expression)
    expression.gsub(/\r/, '').gsub(' ', '')
    expression.gsub(/(?<foo>\d)\(/, '\k<foo>*(')
  end

end