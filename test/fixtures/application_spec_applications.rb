module TestApp
  class MyApp < Trellis::Application
    home :home
    persistent :my_field
    
    map_static ['/images', '/style', '/favicon.ico']
    map_static ['/jquery'], "./js"
    
    MY_CONSTANT_1 = "it's just us, chickens!"
    
    def application_method
      "Zaphod Beeblebrox"
    end
    
  end

  class Home < Trellis::Page 
    pages :other
    
    template do html { body { h1 "Hello World!" }} end
      
    def on_event1 
      self
    end
    
    def on_event2 
      "just some text"
    end
    
    def on_event3 
      @other
    end

    def on_event4(value)
      "the value is #{value}"
    end
  end
  
  class PageWithGetPlainText < Trellis::Page
    pages :other
    
    def get
      "some content"
    end
  end
  
  class PageWithGetRedirect < Trellis::Page
    pages :other
    
    def get
      @other
    end
  end
  
  class PageWithGetSame < Trellis::Page
    pages :other
    
    def get
      self
    end
    
    template do html { body { p "Vera, what has become of you?" }} end
  end
  
  class Other < Trellis::Page    
    template do html { body { p "Goodbye Cruel World " }} end
  end
  
  class BeforeLoad < Trellis::Page
    attr_reader :some_value
    
    def before_load
      @some_value = "8675309"
    end
    
    template do thtml { body { text %[<trellis:value name="some_value"/>] }} end
  end
  
  class AfterLoad < Trellis::Page
    attr_reader :some_value
    
    def after_load
      @some_value = "chunky bacon!"
    end
    
    template do thtml { body { text %[<trellis:value name="some_value"/>] }} end
  end
  
  class BeforeRender < Trellis::Page
    attr_reader :some_value
    
    def before_render
      @some_value = "8675309"
    end
    
    template do thtml { body { text %[<trellis:value name="some_value"/>] }} end
  end
  
  class AfterRender < Trellis::Page
    
    def after_render
      @application.my_field = "changed in after_render method"
    end
    
    template do thtml { body { p { "hey!"} }} end
  end

  class RoutedDifferently < Trellis::Page
    route '/whoa'

    template do html { body { text %[whoa!] }} end
  end
  
  class RoutedDifferentlyWithAParam < Trellis::Page
    route '/hello/:name'

    template do 
      thtml { 
        body { 
          h2 "Hello"
          text %[<trellis:value name="salutation"/><trellis:value name="name"/>]
        }
      } 
    end
  end

  class RoutedDifferentlyWithParams < Trellis::Page
    route '/report/:year/:month/:day'

    template do
      thtml {
        body {
          h2 "Report for"
          text %[<trellis:value name="month"/>]
          text '/'
          text %[<trellis:value name="day"/>]
          text '/'
          text %[<trellis:value name="year"/>]
        }
      }
    end
  end

  class RoutedWithOptionalParams < Trellis::Page
    route '/foobar/?:foo?/?:bar?'

    template do
      thtml {
        body {
          text %[<trellis:value name="foo"/>]
          text '-'
          text %[<trellis:value name="bar"/>]
        }
      }
    end
  end

  class RoutedWithSingleWildcard < Trellis::Page
    route '/splat/*'

    template do
      thtml {
        body {
          text %[<trellis:value name="splat"/>]
        }
      }
    end
  end

  class RoutedWithMultipleWildcards < Trellis::Page
    route '/splats/*/foo/*/*'

    template do
      thtml {
        body {
          text %[<trellis:value name="splat"/>]
        }
      }
    end
  end

  class RoutedWithMixedParams < Trellis::Page
    route '/mixed/:foo/*'

    template do
      thtml {
        body {
          text %[<trellis:value name="splat"/>]
          text '-'
          text %[<trellis:value name="foo"/>]
        }
      }
    end
  end

  class RoutedWithTwoParams < Trellis::Page
    route '/foobar/:foo/:bar'

    template do
      thtml {
        body {
          text %[<trellis:value name="foo"/>]
          text '-'
          text %[<trellis:value name="bar"/>]
        }
      }
    end
  end

  class RoutedWithImplicitDot < Trellis::Page
    route '/downloads/:file.:ext'

    template do
      thtml {
        body {
          text %[<trellis:value name="file"/>]
          text '-'
          text %[<trellis:value name="ext"/>]
        }
      }
    end
  end

  class SamplePage < Trellis::Page
    attr_accessor :value
    template do thtml { body { text %[<trellis:value name="value"/>] }} end
  end

  class AnotherSamplePage < Trellis::Page
    template do thtml { body { text %[<trellis:value name="page_name"/>] }} end
  end

  class HamlPage < Trellis::Page
    template %[!!! XML
!!! Strict
%html{ :xmlns => "http://www.w3.org/1999/xhtml" }
  %head
    %meta{ :content => "text/html; charset=UTF-8", "http-equiv" => "Content-Type" }
    %title
      This is a HAML page
  %body
    %h1
      Page Title
    %p
      HAML rocks!], :format => :haml
  end

  class TextilePage < Trellis::Page
    template %[A *simple* example.], :format => :textile
  end

  class MarkDownPage < Trellis::Page
    template "# This is the Title\n## This is the SubTitle\nThis is some text", :format => :markdown
  end

  class HTMLPage < Trellis::Page
    template "<html><body><h1>This is just HTML</h1></body></html>"
  end
  
  class ERubyPage < Trellis::Page
    attr_reader :list
    
    def initialize
      self
      @list = ["Hey", "bud", "let's", "party!"]
    end
    
    template %[<html><body><ul><?rb for item in @list ?><li>@{item}@</li><?rb end ?></ul></body></html>], :format => :eruby
  end
  
  class ConstantAccessPage < Trellis::Page  
    def greet
      "helloooo, la la la"
    end
     
    template %[<html><body><p>@{TestApp::MyApp::MY_CONSTANT_1}@</p></body></html>], :format => :eruby
  end  
  
  class MethodAccessPage < Trellis::Page  
    def greet
      "helloooo, la la la"
    end
     
    template %[<html><body><p>@{greet}@</p></body></html>], :format => :eruby
  end
  
  class ApplicationDataPage < Trellis::Page  
    
    def on_save
      @application.my_field = "here's a value"
      self
    end
     
    template %[<html><body><p>@{@application.my_field}@</p></body></html>], :format => :eruby
  end
  
  class ApplicationMethodPage < Trellis::Page
    template %[<html><body><p>@{application_method()}@</p></body></html>], :format => :eruby    
  end

end
