<%@ Page Title="Leaderboard | AnatoXplore" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Leaderboard.aspx.cs" Inherits="AnatoXplore.Leaderboard" %> 

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server"> 

<section class="lb-page"> 

    <div class="lb-heading"> 

        <div><p class="lb-eyebrow">ANATOXPLORE COMMUNITY</p><h1>Leaderboard</h1><p class="lb-description">Learn, compete, and rise through the ranks.</p></div> 

    </div> 

 

    <asp:Panel ID="pnlGuest" runat="server" Visible="false" CssClass="lb-guest"> 

        <h2>Join the leaderboard</h2> 

        <p>Sign in or create an account to see the top learners and track your progress.</p> 

        <div class="lb-guest-actions"> 

            <a class="lb-button lb-button-primary" href="<%= ResolveUrl("~/Login.aspx") %>">Log in</a> 

            <a class="lb-button lb-button-secondary" href="<%= ResolveUrl("~/Register.aspx") %>">Create account</a> 

        </div> 

    </asp:Panel> 

 

    <asp:Panel ID="pnlLeaderboard" runat="server" Visible="false"> 

        <div class="lb-layout"> 

            <section class="lb-panel lb-podium-panel"> 

                <div class="lb-panel-heading"><div><h2>Top 3 Learners</h2><p>The highest-ranked learners by total XP.</p></div></div> 

                <asp:Panel ID="pnlNoPodium" runat="server" Visible="false" CssClass="lb-empty">No learners have earned XP yet.</asp:Panel> 

                <div class="lb-podium"> 

                    <asp:Repeater ID="rptPodium" runat="server"> 

                        <ItemTemplate> 

                            <div class='lb-podium-person lb-place-<%# Eval("Rank") %>'> 

                                <div class="lb-avatar-wrap"> 

                                    <%# AnatoXplore.ProfileBadgeRenderer.Render(Eval("ProfilePhotoPath"), Eval("ProfileFrameKey"), Eval("FullName"), "lb-avatar") %> 

                                    <span class="lb-avatar-decoration" aria-hidden="true"><%# Convert.ToInt32(Eval("Rank")) == 1 ? "&#9733;" : (Convert.ToInt32(Eval("Rank")) == 2 ? "&#9670;" : "&#10022;") %></span> 

                                </div> 

                                <div class="lb-person-name"><%#: Eval("FullName") %></div> 

                                <div class="lb-person-xp"><%#: String.Format("{0:N0} XP", Eval("TotalXP")) %></div> 

                                <div class="lb-person-level">Level <%#: Eval("CurrentLevel") %></div> 

                                <div class="lb-podium-block"><span><%#: Eval("Rank") %></span></div> 

                            </div> 

                        </ItemTemplate> 

                    </asp:Repeater> 

                </div> 

            </section> 

 

            <section class="lb-panel lb-rankings-panel"> 

                <div class="lb-panel-heading"><div><h2>Rankings</h2><p>All top 10 learners, including the podium.</p></div><span class="lb-top-ten">TOP 10</span></div> 

                <div class="lb-table-wrapper"> 

                    <asp:GridView ID="gvLeaderboard" runat="server" AutoGenerateColumns="false" CssClass="lb-table" GridLines="None" DataKeyNames="UserID" OnRowDataBound="gvLeaderboard_RowDataBound" ShowHeaderWhenEmpty="true" EmptyDataText="No other learners to display."> 

                        <Columns> 

                            <asp:BoundField DataField="Rank" HeaderText="Rank" /> 

                            <asp:TemplateField HeaderText="Learner"><ItemTemplate><div class="lb-table-user"><%# AnatoXplore.ProfileBadgeRenderer.Render(Eval("ProfilePhotoPath"), Eval("ProfileFrameKey"), Eval("FullName"), "lb-table-avatar") %><span class="lb-table-name"><%#: Eval("FullName") %></span><asp:Label ID="lblYou" runat="server" CssClass="lb-you-badge" Text="You" Visible="false" /></div></ItemTemplate></asp:TemplateField> 

                            <asp:TemplateField HeaderText="Level"><ItemTemplate><span class="lb-level">Level <%#: Eval("CurrentLevel") %></span></ItemTemplate></asp:TemplateField> 

                            <asp:TemplateField HeaderText="Total XP"><ItemTemplate><span class="lb-xp"><%#: String.Format("{0:N0} XP", Eval("TotalXP")) %></span></ItemTemplate></asp:TemplateField> 

                        </Columns> 

                    </asp:GridView> 

                </div> 

                <asp:Panel ID="pnlCurrentUserOutsideTopTen" runat="server" Visible="false" CssClass="lb-outside-note">Your current rank is outside the top 10. Keep learning to climb the leaderboard.</asp:Panel> 

            </section> 

        </div> 

    </asp:Panel> 

</section> 

 

<style> 

.lb-page{--text:#f5f2ff;--muted:#c2b9e9;--purple:#7950ef;--lavender:#b9a4ff;color:var(--text);box-sizing:border-box;width:100%;max-width:none;min-height:calc(100vh - 66px);margin:0;padding:clamp(24px,3vw,42px);border:0;border-radius:0;background:radial-gradient(circle at 78% 9%,rgba(106,70,205,.28),transparent 23%),radial-gradient(circle at 4% 90%,rgba(76,105,222,.18),transparent 25%),linear-gradient(135deg,#21183f,#17132f 52%,#20174b);box-shadow:none;position:relative;overflow:hidden;isolation:isolate} 

.lb-page:before,.lb-page:after{content:"";position:absolute;border:1px solid rgba(157,125,255,.12);border-radius:50%;pointer-events:none;z-index:-1} 

.lb-page:before{width:360px;height:360px;right:-115px;top:-160px;box-shadow:0 0 0 30px rgba(137,95,255,.035),0 0 0 68px rgba(137,95,255,.025)} 

.lb-page:after{width:250px;height:250px;left:-150px;bottom:-100px;box-shadow:0 0 0 35px rgba(137,95,255,.03),0 0 0 75px rgba(137,95,255,.025)} 

.lb-heading{display:flex;align-items:center;justify-content:space-between;gap:18px;margin-bottom:24px;position:relative} 

.lb-eyebrow{margin:0 0 7px;color:var(--lavender);font-size:11px;font-weight:800;letter-spacing:2px} 

.lb-heading h1{margin:0;color:#fff;font-size:clamp(30px,4vw,48px);line-height:1.1;font-weight:800;letter-spacing:-.8px} 

.lb-description{margin:10px 0 0;color:var(--muted);font-size:16px} 

.lb-heading-icon{width:58px;height:58px;flex:0 0 58px;display:grid;place-items:center;border-radius:18px;font-size:28px;color:#d5c6ff;border:1px solid #6e57bd;background:linear-gradient(145deg,rgba(126,80,239,.35),rgba(91,115,226,.12));box-shadow:0 0 30px rgba(128,83,255,.16)} 

.lb-layout{display:grid;grid-template-columns:minmax(360px,.92fr) minmax(460px,1.15fr);gap:16px;align-items:stretch} 

.lb-panel{min-width:0;border:1px solid #6550ae;border-radius:19px;background:linear-gradient(150deg,rgba(48,37,100,.88),rgba(27,23,65,.94));box-shadow:inset 0 1px 0 rgba(255,255,255,.035),0 10px 30px rgba(8,5,27,.12);padding:22px} 

.lb-panel-heading{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;margin-bottom:20px} 

.lb-panel-heading h2{margin:0;font-size:23px;line-height:1.2;color:#fff} 

.lb-panel-heading p{margin:7px 0 0;color:var(--muted);font-size:13px;line-height:1.5} 

.lb-top-ten{border:1px solid #6b57b6;background:rgba(119,83,224,.16);color:#d7cbff;padding:7px 10px;border-radius:999px;font-size:10px;letter-spacing:1px;font-weight:800;white-space:nowrap} 

.lb-podium{display:grid;grid-template-columns:1fr 1.12fr 1fr;align-items:end;gap:8px;min-height:390px;padding-top:6px} 

.lb-podium-person{text-align:center;min-width:0;display:flex;flex-direction:column;align-items:center} 

.lb-avatar-wrap{width:104px;height:104px;position:relative;display:grid;place-items:center;margin-bottom:12px} 

.lb-avatar{display:grid;place-items:center;overflow:hidden;width:82px;height:82px;border-radius:50%;font-size:22px;font-weight:800;color:#fff;background:linear-gradient(145deg,#5942b4,#302c80);border:3px solid #9d83ff;box-shadow:0 0 0 5px rgba(153,124,255,.12),0 0 26px rgba(135,93,255,.28)} 

.lb-place-1 .lb-avatar-wrap{width:126px;height:126px;margin-bottom:10px} 

.lb-place-1 .lb-avatar{width:100px;height:100px;font-size:27px;border-color:#d1baff;box-shadow:0 0 0 6px rgba(173,139,255,.16),0 0 34px rgba(156,111,255,.42)} 

.lb-place-2 .lb-avatar{border-color:#83baff;background:linear-gradient(145deg,#425eb8,#282b78)} 

.lb-place-3 .lb-avatar{border-color:#c19aff;background:linear-gradient(145deg,#6c48b9,#352477)} 

.lb-avatar-decoration{position:absolute;right:0;top:0;color:#bca4ff;font-size:22px;text-shadow:0 0 14px rgba(184,151,255,.5)} 

.lb-place-2 .lb-avatar-decoration{color:#8fc7ff}.lb-place-3 .lb-avatar-decoration{color:#d0a8ff} 

.lb-person-name{max-width:100%;overflow-wrap:anywhere;color:#fff;font-size:14px;font-weight:800} 

.lb-person-xp{margin-top:5px;color:#d6c4ff;font-size:19px;font-weight:900} 

.lb-person-level{margin-top:4px;color:#c1b7e8;font-size:12px} 

.lb-podium-block{display:grid;place-items:center;width:100%;margin-top:12px;border:1px solid rgba(190,166,255,.55);border-bottom:0;border-radius:13px 13px 3px 3px;color:#f6f2ff;font-size:39px;font-weight:900;text-shadow:0 2px 12px rgba(255,255,255,.3);background:linear-gradient(180deg,rgba(133,92,245,.9),rgba(70,53,169,.8));box-shadow:0 -7px 25px rgba(127,88,255,.16),inset 0 1px 0 rgba(255,255,255,.25)} 

.lb-place-2 .lb-podium-block{height:90px;color:#c4e0ff;background:linear-gradient(180deg,#4f6ad4,#35358f);border-color:#829eff} 

.lb-place-1 .lb-podium-block{height:126px;font-size:48px;background:linear-gradient(180deg,#9a70ff,#6040cb);border-color:#d1baff} 

.lb-place-3 .lb-podium-block{height:72px;color:#ead9ff;background:linear-gradient(180deg,#8354d0,#4a318f);border-color:#c29aff} 

.lb-table-wrapper{width:100%;overflow-x:auto} 

.lb-table{width:100%;min-width:430px;border-collapse:separate;border-spacing:0 6px;color:#f6f3ff} 

.lb-table th{text-align:left;padding:12px 10px;color:#c6b9f3;background:rgba(17,15,47,.38);font-size:12px;font-weight:700;white-space:nowrap} 

.lb-table th:first-child{border-radius:10px 0 0 10px}.lb-table th:last-child{border-radius:0 10px 10px 0} 

.lb-table td{padding:12px 10px;background:rgba(20,18,52,.58);border-top:1px solid rgba(111,89,183,.38);border-bottom:1px solid rgba(111,89,183,.38);font-size:13px;white-space:nowrap} 

.lb-table td:first-child{border-left:1px solid rgba(111,89,183,.38);border-radius:11px 0 0 11px;text-align:center;width:50px;font-weight:800} 

.lb-table td:last-child{border-right:1px solid rgba(111,89,183,.38);border-radius:0 11px 11px 0} 

.lb-table tr:hover td{background:rgba(105,79,196,.22)} 

.lb-table-user{display:flex;align-items:center;gap:9px;min-width:135px} 

.lb-table-avatar{overflow:hidden;width:34px;height:34px;flex:0 0 34px;border-radius:50%;display:inline-grid;place-items:center;color:#fff;font-size:10px;font-weight:800;background:linear-gradient(145deg,#7354d2,#3e479d);border:2px solid #a994ff} 

.lb-table-name{color:#f5f1ff;font-weight:600} 

.lb-level{display:inline-block;padding:5px 9px;border-radius:999px;border:1px solid #6855b1;background:rgba(119,84,213,.18);color:#d8ceff;font-size:11px} 

.lb-xp{color:#d8c5ff;font-weight:900} 

.lb-you-badge{display:inline-block;padding:4px 7px;border-radius:999px;color:#fff;background:#7652e9;font-size:10px;font-weight:800} 

.lb-table tr.lb-current-user td{background:linear-gradient(90deg,rgba(109,77,226,.4),rgba(74,103,218,.22));border-top:1px solid #a68cff;border-bottom:1px solid #a68cff} 

.lb-table tr.lb-current-user td:first-child{border-left:2px solid #b9a3ff}.lb-table tr.lb-current-user td:last-child{border-right:2px solid #b9a3ff} 

.lb-outside-note{margin-top:13px;padding:12px 14px;border:1px solid #5f4a9e;border-radius:12px;color:#cfc4f8;background:rgba(94,67,172,.16);font-size:12px;line-height:1.5} 

.lb-empty{color:#cfc4f8;padding:24px 0;text-align:center} 

.lb-guest{max-width:620px;margin:28px auto;text-align:center;padding:38px 24px;border:1px solid #6550ae;border-radius:18px;background:rgba(39,31,83,.85)} 

.lb-guest h2{margin:0 0 10px;color:#fff}.lb-guest p{color:var(--muted);line-height:1.6} 

.lb-guest-actions{display:flex;justify-content:center;flex-wrap:wrap;gap:10px;margin-top:22px} 

.lb-button{display:inline-block;padding:11px 19px;border-radius:10px;text-decoration:none!important;font-weight:800} 

.lb-button-primary{color:#fff!important;background:linear-gradient(135deg,#8055f2,#5735c9);box-shadow:0 6px 18px rgba(103,67,214,.25)} 

.lb-button-secondary{color:#e4dcff!important;border:1px solid #7560b9;background:rgba(111,83,190,.12)} 

@media(max-width:1050px){.lb-layout{grid-template-columns:1fr}.lb-podium{min-height:350px}} 

@media(max-width:560px){.lb-page{width:100%;max-width:none;margin:0;padding:20px 14px;min-height:calc(100vh - 66px)}.lb-heading h1{font-size:31px}.lb-heading-icon{width:46px;height:46px;flex-basis:46px;border-radius:14px}.lb-panel{padding:14px}.lb-panel-heading h2{font-size:20px}.lb-podium{gap:4px;min-height:300px}.lb-avatar-wrap{width:76px;height:82px}.lb-avatar{width:65px;height:65px;font-size:17px}.lb-place-1 .lb-avatar-wrap{width:91px;height:96px}.lb-place-1 .lb-avatar{width:80px;height:80px;font-size:21px}.lb-person-name{font-size:11px}.lb-person-xp{font-size:14px}.lb-person-level{font-size:10px}.lb-podium-block{font-size:30px}.lb-place-2 .lb-podium-block{height:65px}.lb-place-1 .lb-podium-block{height:92px;font-size:38px}.lb-place-3 .lb-podium-block{height:53px}.lb-table th,.lb-table td{padding:10px 8px}} 

 

/* ANATOXPLORE BLUE THEME */ 

.lb-page { 

    --text: #FFFFFF; 

    --muted: #C0D8ED; 

    --purple: #168FE5; 

    --lavender: #8ACBFF; 

 

    background: 

        radial-gradient(circle at 78% 9%, rgba(22,143,229,.22), transparent 23%), 

        radial-gradient(circle at 4% 90%, rgba(40,130,190,.16), transparent 25%), 

        linear-gradient(135deg, #071F3D, #0B3558 52%, #061B33); 

 

    border-color: rgba(80,170,230,.35); 

} 

 

.lb-page:before, 

.lb-page:after { 

    border-color: rgba(100,190,245,.12); 

} 

 

.lb-panel { 

    border-color: #24618C; 

    background: linear-gradient(150deg, rgba(16,55,88,.96), rgba(7,35,65,.97)); 

} 

 

.lb-panel-mark, 

.lb-eyebrow { 

    color: #8ACBFF; 

} 

 

.lb-top-ten { 

    border-color: #247DB7; 

    background: rgba(22,143,229,.15); 

    color: #A9DDFF; 

} 

 

.lb-avatar { 

    background: linear-gradient(145deg, #168FE5, #07518D); 

    border-color: #8ACBFF; 

    box-shadow: 0 0 0 5px rgba(70,170,235,.12), 

                0 0 26px rgba(22,143,229,.25); 

} 

 

.lb-place-1 .lb-avatar { 

    border-color: #B5E3FF; 

} 

 

.lb-place-2 .lb-avatar { 

    background: linear-gradient(145deg, #287CB8, #174A78); 

    border-color: #8ACBFF; 

} 

 

.lb-place-3 .lb-avatar { 

    background: linear-gradient(145deg, #287CB8, #174A78); 

    border-color: #65BCEB; 

} 

 

.lb-person-xp, 

.lb-xp { 

    color: #A9DDFF; 

} 

 

.lb-podium-block { 

    background: linear-gradient(180deg, #168FE5, #07518D); 

    border-color: #65BCEB; 

    box-shadow: 0 -7px 25px rgba(22,143,229,.16); 

} 

 

.lb-place-2 .lb-podium-block { 

    background: linear-gradient(180deg, #287CB8, #174A78); 

    border-color: #8ACBFF; 

} 

 

.lb-place-1 .lb-podium-block { 

    background: linear-gradient(180deg, #D5B75C, #987329); 

    border-color: #F0D58A; 

} 

 

.lb-place-3 .lb-podium-block { 

    background: linear-gradient(180deg, #A96B43, #70432E); 

    border-color: #D99A6A; 

} 

 

.lb-table th { 

    color: #B9DEFA; 

    background: rgba(3,25,48,.55); 

} 

 

.lb-table td { 

    background: rgba(5,31,57,.65); 

    border-color: rgba(80,155,210,.25); 

} 

 

.lb-table td:first-child { 

    border-left-color: rgba(80,155,210,.25); 

} 

 

.lb-table td:last-child { 

    border-right-color: rgba(80,155,210,.25); 

} 

 

.lb-table tr:hover td { 

    background: rgba(22,143,229,.15); 

} 

 

.lb-table-avatar { 

    background: linear-gradient(145deg, #168FE5, #07518D); 

    border-color: #8ACBFF; 

} 

 

.lb-level { 

    border-color: #287CB8; 

    background: rgba(22,143,229,.13); 

    color: #B9DEFA; 

} 

 

.lb-you-badge, 

.lb-button-primary { 

    background: linear-gradient(135deg, #168FE5, #0867B0); 

    color: #FFFFFF !important; 

} 

 

.lb-table tr.lb-current-user td { 

    background: linear-gradient(90deg, rgba(22,143,229,.32), rgba(40,130,190,.18)); 

    border-top-color: #65BCEB; 

    border-bottom-color: #65BCEB; 

} 

 

.lb-table tr.lb-current-user td:first-child { 

    border-left-color: #8ACBFF; 

} 

 

.lb-table tr.lb-current-user td:last-child { 

    border-right-color: #8ACBFF; 

} 

 

.lb-outside-note, 

.lb-guest { 

    border-color: #24618C; 

    background: rgba(10,48,80,.85); 

    color: #C0D8ED; 

} 

 

.lb-button-secondary { 

    color: #C0D8ED !important; 

    border-color: #367DAA; 

    background: rgba(22,143,229,.10); 

} 

 

</style> 

</asp:Content> 