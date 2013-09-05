# Shortest Path

# Submitted By:
# Mason

# Difficulty:
# Hard

# Instructions:
# Given a set of distances between pairs of locations, a source location, and a destination location, return an array of locations visited when traversing the shortest path between the source and destination locations. The source and destination locations should be included at the beginning and end of the visited locations list (respectively). The set of distances is represented as a hash of hashes. The key of the outer hash is the source location name, the key of the inner hash is the destination location name, and the value of the inner hash is the distance between those two points. Distances are single-direction distances; just because the distance from A to B is 4, you cannot assume that the distance from B to A is also 4. If a path does not exist between the source and destination locations passed to your method, return nil. If negative distances exist, don't try to find a shortest path (as it may be infinite). Simply return "Error: Negative Distances in Graph"

# Hidden Code:
# There is hidden code with assertions that is also being run to test out your code.


gem 'minitest'

require 'minitest/autorun'
require 'minitest/pride'


module ShortestPath
  def shortest_path(graph, origin, destination)
    if !graph.has_key?(origin) || !graph.values.map(&:keys).flatten.include?(destination)
      return nil
    end

    graph.values.map(&:values).flatten.each do |distance|
      return "Error: Negative Distances in Graph" if distance < 0 || !distance.is_a?(Numeric)
    end

    def remove_key(graph, key)
      graph.dup.tap {|hash| hash.delete(key)}
    end

    def extend_route(graph, route)
      lastcity = route[-1]
      if graph.has_key?(lastcity)
        new_graph = remove_key(graph, lastcity)
        graph[lastcity].each do |nextcity, distance|
          new_route = route + [nextcity]
          @routes[new_route] = @routes[route] + distance
          extend_route(new_graph, new_route)
        end
      end
    end

    # { [NY,LA]=>10, [NY,LA,SF]=>12 }
    @routes = {}

    graph[origin].each do |nextcity, distance|
      route = [origin, nextcity]
      @routes[route] = distance
      new_graph = remove_key(graph, origin)
      extend_route(new_graph, route)
    end

    all_paths = @routes.select {|route| route[-1] == destination}
    return nil if all_paths.empty?
    all_paths.sort_by {|route, distance| distance}.first.first
  end

  def graph
    {
      "San Francisco" => {"Chicago" => 2132,
                          "Dallas" => 1734,
                          "Miami" => 9999},
      "Chicago" => {"Durham" => 781},
      "Dallas" => {"Durham" => 1176},
      "Durham" => {"Miami" => 300,
                   "Chicago" => 250},
      "New York" => {"Los Angeles" => 399}
    }
  end
end

class ShortestTest < MiniTest::Test
  include ShortestPath

  def test_shortest_found
    assert_equal shortest_path(graph, "San Francisco", "Durham"), ["San Francisco", "Dallas", "Durham"]
  end

  def test_shortest_found2
    assert_equal shortest_path(graph, "San Francisco", "Miami"), ["San Francisco", "Dallas", "Durham", "Miami"]
  end

  def test_shortest_not_found
    assert_equal shortest_path(graph, "Durham", "San Francisco"), nil
  end

  def test_shortest_not_found2
    assert_equal shortest_path(graph, "San Francisco", "San Diego"), nil
  end

  def test_shortest_not_found3
    assert_equal shortest_path(graph, "San Francisco", "Los Angeles"), nil
  end
end