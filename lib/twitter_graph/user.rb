require 'twitter'
module TwitterGraph
  class User
    attr_reader :id, :follower_ids, :friend_ids,
                :mutual_follow_ids, :screen_name, :depth
    def initialize(id, depth)
      @id = id
      @depth = depth
    end
    
    def create_graph(api_client)
      make_follower_list(api_client)
      make_friend_list(api_client)
      make_mutual_follow_list
    end

    def show_graph
      @mutual_follow_ids.each do |mutual_id|
        puts "#{@id} #{mutual_id}"
      end
    end

    def make_follower_list(api_client)
      @follower_ids = []
      api_client.follower_ids(@id).each do |follower|
        @follower_ids.push(follower)
      end
    end

    def make_friend_list(api_client)
      @friend_ids = []
      api_client.friend_ids(@id).each do |friend|
        @friend_ids.push(friend)
      end
    end

    def make_mutual_follow_list
      @mutual_follow_ids = []
      mutual_hash = Hash.new(0)
      @follower_ids.each do |follower|
        mutual_hash[follower] += 1
      end
      @friend_ids.each do |friend|
        mutual_hash[friend] += 1
      end
      mutual_hash.each do |id, count|
        if(count >= 2)
          @mutual_follow_ids.push(id)
        end
      end
    end
  end
end
