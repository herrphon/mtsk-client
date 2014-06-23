require 'pp'
require 'optparse'

module UTIL
  class DuplicateOption < OptionParser::ParseError
    const_set(:Reason, 'duplicate option'.freeze)
  end

  ##
  # The OptParser class
  #
  # Usage: 1. Create an object
  #        2. Add the wanted options with the option method
  #        3. Trigger the parsing with the parse method
  #
  class OptParser < OptionParser

    attr_reader :result

    def initialize
      super()
      @result = {}
      @flags = {}
      @plain_args=[]
      @plain_args_ary = nil
    end

    def plain_args_to_ary a
      @plain_args_ary = a
      def_result_option a, []
    end

    def plain_args_to *a
      @plain_args += a
      a.each do |n|
        # Set default and define method
        # (even if usually duplicate),
        # we want to be able to collect
        # plain args that are not actual
        # option values.
        def_result_option n, nil
      end
    end

    ##
    # add an option to the parser
    #
    def option( name, *args )
      shopt=nil
      descr="Huh?"
      type=nil
      longopt="--"+name.to_s.gsub(/_/,'-')

      flg={}
      @flags[name] = flg

      args.each do |a|
        if a.is_a? String
          if a =~ /^--[^\s]+/
            longopt = a
          elsif a =~ /^-.$/
            shopt = a
          else
            descr = a
          end
        elsif a.is_a? Class
          type = a
        elsif a.is_a? Symbol
          case a
            when :list
              flg[:list] = true
            when :once
              flg[:once] = true
            else
              raise "opt_parse#option: can't deal with symbols"
          end
        elsif a.is_a? Hash
          raise "opt_parse#option: can't deal with hashes"
        else
          raise "opt_parse#option: can't deal with #{a.inspect}"
        end
      end

      onargs=[]

      if shopt
        onargs <<= shopt
      end

      if type
        # option of type String, Array, etc.
        # (And 'Array' is pretty pointless and doesn't mean what you
        #  may think it means; you probably want :list instead.)
        def_result_option( name, nil )
        onargs <<= "#{longopt} #{type}"
        onargs <<= type
      else
        # type = nil  =>  Boolean
        def_result_option( name, false )
        onargs <<= "#{longopt}"
      end
      if descr
        onargs <<= descr
      end
      # puts "onargs: #{onargs.inspect}"
      on(*onargs) { |setting|
        if longopt =~ /^--no-/
          setting=true if setting==false
        end
        set_result_option( name, setting )
      }
    end


    ##
    # set the option of the result and define the method for that option
    #
    def def_result_option( name, value )
      ##
      # magically add a method to the @result Hash object
      # without adding it to all Hash classes
      #
      (class << @result; self; end).class_eval {
        define_method( name ) {
          return self[ name ]
        }
      }
      set_result_option name, value
    end

    def set_result_option( name, value )
      ##
      # add the option to the result hash
      # (Note: Necessary value conversion should be in here;
      # as we use the raw 'value' for an error message.)
      #
      if @flags[name] and @flags[name][:list]
        @result[ name ] ||= []
        # The 'if value' is a total hack around the initialization...
        @result[ name ] <<= value if value
      else
        if @result[name] and @flags[name] and @flags[name][:once]
          raise DuplicateOption.new("#{value.inspect} for #{name}")
        end
        @result[ name ] = value
      end
    end

    # Overriding OptionParser#order! to catch arguments
    # to be passed into option values.
    def order! args, &b
      super args do |a|
        if @plain_args.length > 0
          set_result_option @plain_args.shift, a
        elsif @plain_args_ary
          @result[@plain_args_ary] <<= a
        else
          b.call a
        end
      end
    end

    def order_no_args args
      order args do |arg|
        raise OptionParser::NeedlessArgument.new(arg.inspect)
      end
    end
  end
end