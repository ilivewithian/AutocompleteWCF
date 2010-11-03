using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Web;
using System.Web.Caching;
using System.IO;

namespace AutoCompleteExample
{
    public class WordResult
    {
        public string Word { get; set; }
        public int Length { get; set; }
        public string Reversed { get; set; }
    }

    [ServiceContract(Namespace = "autocomplete.theoldsewingfactory.com")]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class AutoComplete
    {
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        public WordResult[] WordLookup(string text, int count)
        {
            count = count > 20 ? 20 : count;
            count = count < 0 ? 1 : count;

            var result = (from word in GetAllWords()
                          where word.Contains(text)
                          select new WordResult
                          {
                              Word = word,
                              Length = word.Length,
                              Reversed = Reverse(word)
                          })
                          .Take(count)
                          .ToArray();
            return result;
        }

        public static string Reverse(string s)
        {
            char[] charArray = s.ToCharArray();
            Array.Reverse(charArray);
            return new string(charArray);
        }

        private IList<string> GetAllWords()
        {
            var words = HttpContext.Current.Cache["words"] as IList<string>;
            if (words == null)
            {
                var path = HttpContext.Current.Server.MapPath("~/App_Data/WordList.txt");

                using (var sr = new StreamReader(path))
                {
                    words = new List<string>();
                    string word;
                    while ((word = sr.ReadLine()) != null)
                    {
                        words.Add(word);
                    }

                    var dependency = new CacheDependency(path);
                    HttpContext.Current.Cache.Insert("words", words, dependency);
                }
            }

            return words;
        }
    }
}
