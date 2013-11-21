module MappingSupport

  def use_map(map)
    resource, definitions = map.first
    options = definitions.delete(:spigot) || definitions.delete('spigot')

    Spigot.define do
      service :github do
        resource resource.to_sym do
          definitions.each_pair{|k, v| send(k.to_sym, v) }
          spigot{ options.each_pair{|k,v| send(k.to_sym, v) } } if options
        end
      end
    end

  end


end
