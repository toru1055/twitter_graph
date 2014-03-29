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
        while user = @user_queue.pop
          if(!@done_user[user.id] &&
             user.depth < max_depth)
            begin
              user.create_graph(@twitter_client)
            rescue => err
              warn "err.class: #{err.class}"
              warn "err.message: #{err.message}"
              warn "err.backtrace: #{err.backtrace}"
              @done_user[user.id] = true
              next
            end
            if(user.mutual_follow_ids.count > 1000 &&
               user.depth != 0)
              @done_user[user.id] = true
              next
            end
            user.show_graph
            @done_user[user.id] = true
            if(user.depth + 1 < max_depth)
              user.mutual_follow_ids.each do |mfid|
                next_user = User.new(mfid, user.depth+1)
                @user_queue.push(next_user)
              end
            end
          end
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
