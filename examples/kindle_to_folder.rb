require 'kindle_highlights'

def sanitize_filename(filename)
  filename
    .split(/(?<=.)\.(?=[^.])(?!.*\.[^.])/m)
    .map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
    .join('.')
end

kindle = KindleHighlights::Client.new(
  email_address: "aaa@aaa.com",
  password: "password"
)

base_folder = File.expand_path('~/Kindle') #Folder you want to store the txt files (in markdown format) in...

kindle.books.each do |book|
  folder_name = "#{base_folder}/#{sanitize_filename(book.title)}.txt"
  print book.title+"\r\n" #Print name of Book to console so you can track progress
  bookfile = File.open(folder_name, "w")
    bookfile.puts "# #{book.title} by #{book.author} \r\n" #Header of the Book Title and Author
    book.highlights_from_amazon.each do |highlight|
      bookfile.puts "#{highlight.text}" #Insert Highlighted Text 
      if highlight.page.present? 
        bookfile.puts "_Page: #{highlight.page}_ \r\n"  #Add the Page Number if available
      else
        bookfile.puts "_Location: #{highlight.location}_ \r\n"  #Add the Location if page isn't available
      end
      if highlight.note.present?
        bookfile.puts "**Note:**  #{highlight.note} \r\n" #If there's a Note attached to the highlight add this below the highlighted text
      end
      bookfile.puts "\r\n [Open in Kindle App](kindle://book?action=open&asin=#{book.asin}&location=#{highlight.location})\r\n\r\n" #Add a link to the highlight in the Kindle App
    end
bookfile.close
end
