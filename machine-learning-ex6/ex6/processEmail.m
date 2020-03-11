%Received email, all the contents of email are in variable email_contents
%this variable has been passed to our function processEmail 
%by ex6_spam.m
function word_indices = processEmail(email_contents)
%PROCESSEMAIL preprocesses a the body of an email and
%returns a list of word_indices 
%   word_indices = PROCESSEMAIL(email_contents) preprocesses 
%   the body of an email and returns a list of indices of the 
%   words contained in the email. 
%

% Load Vocabulary
vocabList = getVocabList();
%now after calling vocablist all words given in vocab.txt have now been 
%stored as elements in vocabList vector array



%now we have to return an array of word indices as per vocabList which are also in email
%for this word indices array, we first create an empty array
% Init return value
word_indices = [];

% ========================== Preprocess Email ===========================

% Find the Headers ( \n\n and remove )
% Uncomment the following lines if you are working with raw emails with the
% full headers

% hdrstart = strfind(email_contents, ([char(10) char(10)]));
% email_contents = email_contents(hdrstart(1):end);

% Lower case
%since the software is case sensitive, hence to compare words of vocabList with
%contents of email, both have to be in the same case. either lower or upper
%since our vocabList is in Lowercase, we convert the email content to lowercase.
email_contents = lower(email_contents);

% Strip all HTML from email contents which is now in lowercase
% Looks for any expression that starts with < and ends with > and replace
% and does not have any < or > in the tag it with a space

%outstr = regexprep (string, pat, repstr) 
%Replace occurrences of pattern pat (second argument) in string (first argument) 
%with repstr (third argument)
email_contents = regexprep(email_contents, '<[^<>]+>', ' ');

% Handle Numbers- convert all digits in email to word- "number"
% Look for one or more characters between 0-9
email_contents = regexprep(email_contents, '[0-9]+', 'number');

% Handle URLS - convert all http url related links to word - "httpaddr"
% Look for strings starting with http:// or https://
email_contents = regexprep(email_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');

% Handle Email Addresses- convert all email address links in emails to word - "emailaddr"
% Look for strings with @ in the middle
email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');

% Handle $ sign- replace all $ symbols with word - "dollar"
email_contents = regexprep(email_contents, '[$]+', 'dollar');

%Now we have email_contents which is a string and cleaned off 

% ========================== Tokenize Email ===========================

% Output the email to screen as well
fprintf('\n==== Processed Email ====\n\n');

% Process file
l = 0;
% isempty(a) function is of octave and it Return true if a is an empty matrix 
%(any one of its dimensions is zero). 
%so while loop will continue as long as we have data in email_contents

while ~isempty(email_contents)

    % Tokenize and also get rid of any punctuation
    
    %strtok function returns Find all characters in the string 
    %str up to, but not including, the first character which is in the string delim. 
    %default delimiter is space
    %example
    %[tok, rem] = strtok ("14*27+31", "+-*/")
    % tok = 14
    % rem = *27+31 
    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    % Remove any non alphanumeric characters
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    %now str has been obtained from the email_contents as a token 
    %str has also been cleaned
    % Stem the word 
    % (the porterStemmer sometimes has issues, so we use a try catch block)
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;

    % Skip the word if it is too short
    if length(str) < 1
       continue;
    end

    % Look up the word in the dictionary and add to word_indices if
    % found
    % ====================== YOUR CODE HERE ======================
    % Instructions: Fill in this function to add the index of str to
    %               word_indices if it is in the vocabulary. At this point
    %               of the code, you have a stemmed word from the email in
    %               the variable str. You should look up str in the
    %               vocabulary list (vocabList). If a match exists, you
    %               should add the index of the word to the word_indices
    %               vector. Concretely, if str = 'action', then you should
    %               look up the vocabulary list to find where in vocabList
    %               'action' appears. For example, if vocabList{18} =
    %               'action', then, you should add 18 to the word_indices 
    %               vector (e.g., word_indices = [word_indices ; 18]; ).
    % 
    % Note: vocabList{idx} returns a the word with index idx in the
    %       vocabulary list.
    % 
    % Note: You can use strcmp(str1, str2) to compare two strings (str1 and
    %       str2). It will return 1 only if the two strings are equivalent.
    %
    
    for i =  1:length(vocabList),
      if(strcmp(str, vocabList(i)));
      word_indices = [word_indices; i];
      end
    endfor









    % =============================================================


    % Print to screen, ensuring that the output lines are not too long
    if (l + length(str) + 1) > 78
        fprintf('\n');
        l = 0;
    end
    fprintf('%s ', str);
    l = l + length(str) + 1;

end

% Print footer
fprintf('\n\n=========================\n');

end
