require 'twitter'
require 'twitter_graph/user'
require 'thread'
module TwitterGraph
  class Client
    attr_reader :done_user
    def initialize(twitter_client)
      @twitter_client = twitter_client
    end

    def run(source_ids, max_depth = 2)
      @done_user = Hash.new(false)
      @user_queue = Queue.new
      # Thread Start
      th1 = Thread.start do
        STDOUT.sync = true
        begin
          while user = @user_queue.pop
            if(!@done_user[user.id] &&
               user.depth < max_depth)
              user.create_graph(@twitter_client)
              if(user.mutual_follow_ids.count > 1000 &&
                 user.depth != 0)
                next
              end
              user.show_graph
              if(user.depth + 1 < max_depth)
                user.mutual_follow_ids.each do |mfid|
                  next_user = User.new(mfid, user.depth+1)
                  @user_queue.push(next_user)
                end
              end
            end
          end
        rescue ThreadError => e
          Thread.exit
        end
      end
      # Push first users to the queue
      source_ids.each do |uid|
        @user_queue.push(User.new(uid, 0))
      end
      th1.join
    end
  end
end
