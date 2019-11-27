# A interface Command declara um método para executar um comand.
class Command
  # @abstract
  def execute
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Alguns commands podem implementar operaçõeos simples por conta deles.
class SimpleCommand < Command
  # @param [String] payload
  def initialize(payload)
    @payload = payload
  end

  def execute
    puts "SimpleCommand: See, I can do simple things like printing (#{@payload})"
  end
end

# Contudo, alguns commands podem delegar mais operações complexas para outros objetos,
# chamados "receivers".
class ComplexCommand < Command
  # Commands complexos podem aceitar um ou muitos objetos receiver junto com qualquer outro
  # dados de contexto por meio do construtor.
  def initialize(receiver, a, b)
    @receiver = receiver
    @a = a
    @b = b
  end

  # Commands podem delegar para quisquer métodos de um receiver (receptor).
  def execute
    print 'ComplexCommand: Complex stuff should be done by a receiver object'
    @receiver.do_something(@a)
    @receiver.do_something_else(@b)
  end
end

# As classes Receiver contém algumas lógicas de negócio importantes. Eles sabem como
# performar todos os tipos de operações, associado à realização de uma solicitação. 
# De fato, alguma classe pode servir como Receiver.
class Receiver
  # @param [String] a
  def do_something(a)
    print "\nReceiver: Working on (#{a}.)"
  end

  # @param [String] b
  def do_something_else(b)
    print "\nReceiver: Also working on (#{b}.)"
  end
end

# O Invoker está associado a um ou vários commands. Ele envia uma requisição/solicitação para 
# o command.
class Invoker
  # Inicializa os commands.

  # @param [Command] command
  def on_start=(command)
    @on_start = command
  end

  # @param [Command] command
  def on_finish=(command)
    @on_finish = command
  end

  # O Invoker não depende de command concreto ou classes receiver. O
  # Invoker passa uma solicitação para um recptor indiretamente, executando uma command.
  def do_something_important
    puts 'Invoker: Does anybody want something done before I begin?'
    @on_start.execute if @on_start.is_a? Command

    puts 'Invoker: ...doing something really important...'

    puts 'Invoker: Does anybody want something done after I finish?'
    @on_finish.execute if @on_finish.is_a? Command
  end
end

# O código do cliente pode parametrizar um invoker (invocador) com qualquer command.
invoker = Invoker.new
invoker.on_start = SimpleCommand.new('Say Hi!')
receiver = Receiver.new
invoker.on_finish = ComplexCommand.new(receiver, 'Send email', 'Save report')

invoker.do_something_important