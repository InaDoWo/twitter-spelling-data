# authentication
require 'oauth'
# parsing
require 'json'
# spell check
require 'ffi/aspell'
# require access token
def prepare_access_token(oauth_token, oauth_token_secret)
    consumer = OAuth::Consumer.new("Ze0Ja7f2M1BhT8vt7LaHMSM50", "yydj5l78TGzMwBlUESTvCgnAexNOFCoXEjxDaQQsMG1RJZfRN4", { :site => "https://api.twitter.com", :scheme => :header })

    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )

    return access_token
end
# spelling score for tweets in given location
def determine_spelling_score(geocode)
  # get access token
  access_token = prepare_access_token("4873579859-toRZ6qZEphzR9pYhGgVQQ3MC3QiyVLHhw3NuEVB", "oAvhpDVPHbIYrlbCi7lHTmwICQG1ed9vi0IsaswnJ1msP")
  # get 100 tweets by location
  response = access_token.request(:get, "https://api.twitter.com/1.1/search/tweets.json?q=&geocode=#{geocode}&lang=en&result_type=mixed&count=100")
  # parse JSON output
  parsed_output = JSON.parse(response.body)
  # access tweet information
  tweets = parsed_output['statuses']
  percentage_sum_correct_words = 0
  # go through every tweet
  tweets.each do |tweet|
    # delete all non alphanumerical characters from the tweet except for @, # and ' characters
    tweet_cleaned = tweet['text'].gsub(/[^a-z\s@#']/i, '')
    # split tweet in words
    words_in_tweet = tweet_cleaned.split( )
    speller = FFI::Aspell::Speller.new('en_GB')
    count_correct_words = 0
    count_invalid = 0
    # go through every word
    words_in_tweet.each do |word|
      # check if word is written correctly
      spelled_correctly = speller.correct?(word)
      # count correctly written words
      if spelled_correctly then
        count_correct_words = count_correct_words + 1
      end
      # count words containing #, @ and http to exclude them from valid words
      if !spelled_correctly
        if word.include? '#' or word.include? '@' or word.include? 'http'
          count_invalid = count_invalid + 1
        end
      end
    end
    # calculate number of valid words
    valid_words = words_in_tweet.length - count_invalid
    # calculate score of correctly written words per tweet
    percentage_correct_words = count_correct_words.to_f / valid_words.to_f
    # sum up scores of all tweets
    percentage_sum_correct_words = percentage_sum_correct_words + percentage_correct_words
  end
  # calculate overall score
  percentage_correct_words_overall = percentage_sum_correct_words / tweets.length.to_f

  return percentage_correct_words_overall
end
# calculate scores for London and Exeter
score_london = determine_spelling_score('51.500083,-0.126182,10km') * 100
score_exeter = determine_spelling_score('50.7184120,-3.5338990,3km') * 100

if score_london < score_exeter
  higher_score = score_exeter
  lower_score = score_london
  better_speller = 'London'
  worse_speller = 'Exeter'
else
  higher_score = score_london
  lower_score = score_exeter
  better_speller = 'Exeter'
  worse_speller = 'London'
end
# print result
puts "Twitter users in #{better_speller} have a score of #{higher_score} while Twitter users in #{worse_speller} only have a score of #{lower_score}."
puts "Twitter users spell better in #{better_speller} "
