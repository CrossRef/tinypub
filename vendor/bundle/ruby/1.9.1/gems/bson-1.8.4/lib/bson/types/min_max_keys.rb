module BSON

  # A class representing the BSON MaxKey type. MaxKey will always compare greater than
  # all other BSON types and values.
  #
  # @example Sorting (assume @numbers is a collection):
  #
  #   >> @numbers.save({"n" => Mongo::MaxKey.new})
  #   >> @numbers.save({"n" => 0})
  #   >> @numbers.save({"n" => 5_000_000})
  #   >> @numbers.find.sort("n").to_a
  #   => [{"_id"=>4b5a050c238d3bace2000004, "n"=>0},
  #       {"_id"=>4b5a04e6238d3bace2000002, "n"=>5_000_000},
  #       {"_id"=>4b5a04ea238d3bace2000003, "n"=>#<Mongo::MaxKey:0x1014ef410>},
  #      ]
  class MaxKey

    def ==(obj)
      obj.class == MaxKey
    end
  end

  # A class representing the BSON MinKey type. MinKey will always compare less than
  # all other BSON types and values.
  #
  # @example Sorting (assume @numbers is a collection):
  #
  #   >> @numbers.save({"n" => Mongo::MinKey.new})
  #   >> @numbers.save({"n" => -1_000_000})
  #   >> @numbers.save({"n" => 1_000_000})
  #   >> @numbers.find.sort("n").to_a
  #   => [{"_id"=>4b5a050c238d3bace2000004, "n"=>#<Mongo::MinKey:0x1014ef410>},
  #       {"_id"=>4b5a04e6238d3bace2000002, "n"=>-1_000_000},
  #       {"_id"=>4b5a04ea238d3bace2000003, "n"=>1_000_000},
  #      ]
  class MinKey

    def ==(obj)
      obj.class == MinKey
    end
  end
end
