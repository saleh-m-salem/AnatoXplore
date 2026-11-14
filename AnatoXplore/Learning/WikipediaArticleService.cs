using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;

namespace AnatoXplore.Learning
{
    public static class WikipediaArticleService
    {
        public static DataTable GetArticles(string[,] topics)
        {
            DataTable articles = new DataTable(); articles.Columns.Add("Title"); articles.Columns.Add("Summary"); articles.Columns.Add("Link");
            string titles = "";
            for (int i = 0; i < topics.GetLength(0); i++) { if (i > 0) titles += "|"; titles += topics[i, 1]; }
            try
            {
                string url = "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=extracts%7Cinfo&exintro=1&explaintext=1&inprop=url&redirects=1&titles=" + Uri.EscapeDataString(titles);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url); request.Method="GET"; request.Timeout=10000; request.ReadWriteTimeout=10000; request.UserAgent="AnatoXplore/1.0 (educational student project)";
                string json; using (HttpWebResponse response=(HttpWebResponse)request.GetResponse()) using (Stream stream=response.GetResponseStream()) using (StreamReader reader=new StreamReader(stream)) json=reader.ReadToEnd();
                JavaScriptSerializer serializer=new JavaScriptSerializer(); var data=serializer.Deserialize<Dictionary<string,object>>(json);
                var query=data.ContainsKey("query")?data["query"] as Dictionary<string,object>:null; var pages=query!=null&&query.ContainsKey("pages")?query["pages"] as Dictionary<string,object>:null;
                Dictionary<string,string> aliases=new Dictionary<string,string>(StringComparer.OrdinalIgnoreCase);
                if(query!=null) foreach(string group in new[]{"normalized","redirects"}) if(query.ContainsKey(group)) { object[] list=query[group] as object[]; if(list!=null) foreach(object item in list) { var m=item as Dictionary<string,object>; if(m!=null&&m.ContainsKey("from")&&m.ContainsKey("to")) aliases[Convert.ToString(m["from"]).Replace(' ','_')]=Convert.ToString(m["to"]).Replace(' ','_'); } }
                Dictionary<string,Dictionary<string,object>> byTitle=new Dictionary<string,Dictionary<string,object>>(StringComparer.OrdinalIgnoreCase);
                if(pages!=null) foreach(var pair in pages) { var page=pair.Value as Dictionary<string,object>; if(page!=null&&page.ContainsKey("title")) byTitle[Convert.ToString(page["title"]).Replace(' ','_')]=page; }
                for(int i=0;i<topics.GetLength(0);i++)
                {
                    string resolved=topics[i,1]; for(int n=0;n<10;n++){string next;if(!aliases.TryGetValue(resolved,out next)||String.Equals(resolved,next,StringComparison.OrdinalIgnoreCase)) break; resolved=next;}
                    Dictionary<string,object> page=null; if(!byTitle.TryGetValue(resolved,out page)) byTitle.TryGetValue(resolved.Replace('_',' '),out page); if(page==null) continue;
                    string summary=page.ContainsKey("extract")?Convert.ToString(page["extract"]):""; string link=page.ContainsKey("fullurl")?Convert.ToString(page["fullurl"]):"https://en.wikipedia.org/wiki/"+resolved;
                    if(String.IsNullOrWhiteSpace(summary)) summary="Open the article to learn more about this anatomy topic."; if(summary.Length>430) summary=summary.Substring(0,427).TrimEnd()+"...";
                    articles.Rows.Add(topics[i,0],summary,link);
                }
            }
            catch(Exception ex){System.Diagnostics.Debug.WriteLine("Wikipedia article API error: "+ex);}
            return articles;
        }
    }
}
