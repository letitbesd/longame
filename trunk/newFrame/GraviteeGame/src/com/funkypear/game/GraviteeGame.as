package com.funkypear.game
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;
	
	import com.funkypear.game.*;
    public class GraviteeGame extends Sprite
    {
        public var _1725:int = 0;
        public var _1726:int = 0;
        public var setupMines:Array;
        public var _1727:String = "";
        public var _172b:BitmapData;
        public var _172d:int = -1;
        public var _17210:String = "shoot";
        public var _1734:MovieClip;
        public var _1735:TeamDisplayBar;
        public var _1737:Array = [];
        public var _173c:MovieClip;
        public var _173f:ShieldNode;
        public var _1741:TargetProjectile;
        public var _1743:Array;
        public var _1746:Number;
        public var gameTimer:GameTimer;
        public var _1749:int = 0;
        public var _174a:int = 0;
        public var _174b:int = 0;
        public var _174c:Array;
        public var _mines:Array;
        public var aiming:Boolean = false;
        public var _175b:int = 5000;
        public var _175c:MovieClip;
        public var _175d:Array;
        public var _175f:int = -1;
        public var _17510:Array;
        public var teamHealths:Array;
        public var _1763:Array;
        public var _1764:MovieClip;
        public var _1766:MovieClip;
        private var _1767:Point;
        public var _1768:int = 0;
        public var debugLayer:MovieClip;
        public var _176c:int = 1;
        public var setupPlanets:Array;
        public var _176f:int = 1;
        public var _17610:Array;
        public var _1772:int = 0;
        public var _1775:Bitmap;
        public var setupShields:Array;
        public var _1778:MovieClip;
        public var _1779:Array;
        public var _177c:int = 5000;
        public var _177d:Array = [];
        public var shake:Number = 0;
        public var _177f:Boolean = false;
        public var _17710:Array;
        public var _118d:Array;
        public var setupUnits:Array;
        public var _1783:Array;
        public var _1784:Array;
        public var _1785:MovieClip;
        public var _1787:int = 0;
        public var _cam:Cam;
        public var _1789:int = -1;
        public var _178a:int = 0;
        public var _178c:Array;
        public var _178d:int = -1;
        public var _178e:int = 0;
        public var _17810:Array;
        public var _1791:int = 0;
        public var _1793:Boolean = false;
        public var _1794:int = 0;
        public var _1795:int = 0;
        public var _1796:Boolean = false;
        public var _1797:int = 0;
        public var myTeamsTurn:Boolean = true;
        public var _wepIcon:WepIcon = new WepIcon();
        public var _179b:Number = 1;
        public var _179c:int = 0;
        public var _179d:int = 0;
        public var _179f:String = "";
        public var _17a1:Array;
        public var _17a2:Array = [];
        public var _17a3:int = 0;
        public var _17a4:Array;
        public var _17a5:int = 0;
        public var _17a6:Array = [];
        public var _17a9:MovieClip;
        public var panelWeps:WepPanel;
        public var _17ab:TurnDisplay;
        public var classicGFX:Boolean = false;
        public var _17ad:MovieClip;
        public var _17ae:Array;
        private var _17af:Point;
        public var _17a10:WepPos;
        public var _projectileArr:Array = [];
        public var _17b6:Array = [new Particle6(0, 0), new Particle9(0, 0)];
        public var _17be:int = 0;
        public var _17b10:int = 4;
        public var expSize:int;
        public var _17c2:Number = 5;
        public var _17c6:Arrow;
        public var _17c7:Rectangle;
        public var _plantes:Array = [];
        public var _17c9:int = -1;
        public var _17ce:Array = [];

        public function GraviteeGame(param1)
        {
            _17610 = [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            _174c = [-1, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            classicGFX = false;
            _1741 = new TargetProjectile();
            teamHealths = new Array();
            _17a1 = new Array();
            _17710 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
            _1735 = new TeamDisplayBar();
            _1779 = new Array();
            _1783 = [0, 0, 0, 0];
            _mines = new Array();
            _17a4 = new Array();
            _17ae = new Array();
            _17810 = new Array();
            _178c = [5, 5, 5, 5];
            _17a10 = new WepPos();
            myTeamsTurn = true;
            gameTimer = new GameTimer(45);
            _1743 = new Array();
            _17c7 = new Rectangle(0, 0, 700, 500);
            _1784 = new Array();
            _1763 = new Array();
            _175d = new Array();
            _178e = 0;
            panelWeps = new WepPanel();
            _176c = 1;
            _17c2 = 5;
            _118d = [16711680, 39423, 10079232, 16763904];
            _cam = new Cam();
            _172b = new BitmapData(700, 500, true, 0);
            _1775 = new Bitmap(_172b);
            _17ab = new TurnDisplay();
            _17c6 = new Arrow();
            _17b10 = 4;
            _17510 = [25, 15, 0, 0, 0, 0, 0];
            _1785 = new MovieClip();
            _175c = new MovieClip();
            _1734 = new MovieClip();
            _1764 = new MovieClip();
            _173c = new MovieClip();
            debugLayer = new MovieClip();
            _17ad = new MovieClip();
            _17a9 = new MovieClip();
            _1778 = new MovieClip();
            _1766 = new MovieClip();
            addChild(_1785);
            addChild(_1775);
            addChild(_1778);
            addChild(_175c);
            addChild(_173c);
            addChild(_1764);
            addChild(_17c6);
            addChild(_1734);
            addChild(_17ad);
            addChild(_17a9);
            classicGFX = param1;
            addChild(_1766);
            _1766.addChild(_17ab);
            _1766.addChild(gameTimer);
            _1766.addChild(panelWeps);
            _1766.addChild(_wepIcon);
            gameTimer.x = 8;
            gameTimer.y = 8;
            panelWeps.x = 532;
            panelWeps.y = 121;
            _wepIcon.x = 629;
            _wepIcon.y = 429;
            _17ab.x = 554;
            _17ab.y = 32;
            _wepIcon.addEventListener(MouseEvent.MOUSE_DOWN, wepIconClicked);
            addEventListener(Event.ENTER_FRAME, mainLoop);
            addChild(debugLayer);
            _1766.addChild(_1735);
            _1735.mouseEnabled = false;
            _1735.mouseChildren = false;
            _1735.y = 440;
            if (stage)
            {
                _1738();
            }
            else
            {
                addEventListener(Event.ADDED_TO_STAGE, _1738);
            }// end else if
            return;
        }// end function

        public function _1728(param1:KeyboardEvent)
        {
            var _loc_2:Boolean;
            var _loc_3:int;
            if (param1.keyCode == 82)
            {
                doRestart();
            }
            else if (param1.keyCode == 80)
            {
                if (_177f)
                {
                    doUnpause();
                }
                else
                {
                    doPause();
                }// end else if
            }
            else
            {
                _loc_2 = false;
                _loc_3 = 0;
                while (_loc_3 < _1763.length)
                {
                    // label
                    if (_1763[_loc_3] == param1.keyCode)
                    {
                        _loc_2 = true;
                    }// end if
                    _loc_3++;
                }// end while
                if (true)
                {
                    _1763.push(param1.keyCode);
                }// end else if
            }// end else if
            return;
        }// end function

        public function _1729()
        {
            var _loc_1:Array;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:Number;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:Number;
            _loc_1 = [1, 0, 0, 0];
            _17b10 = 1;
            _loc_7 = 6;
            while (_loc_7 < setupUnits.length)
            {
                // label
                if (_loc_1[setupUnits[_loc_7][2]] == 0)
                {
                    _17b10++;
                }// end if
                var _loc_13:* = _loc_1;
                var _loc_14:* = setupUnits[_loc_7][2];
                _loc_13[_loc_14] = _loc_1[setupUnits[_loc_7][2]]++;
                _loc_7++;
            }// end while
            _loc_2 = 1;
            _loc_3 = _loc_2;
            while (_1779.length < _17b10--)
            {
                // label
                if (_loc_3 != 0)
                {
                    _1779.push(_loc_3);
                }// end if
                _loc_3++;
            }// end while
            _loc_4 = 0;
            while (_loc_4 < setupPlanets.length)
            {
                // label
                _17bf(setupPlanets[_loc_4][0], setupPlanets[_loc_4][1], setupPlanets[_loc_4][2], setupPlanets[_loc_4][3]);
                _loc_4++;
            }// end while
            _loc_7 = 0;
            while (_loc_7 < 10)
            {
                // label
                _17710[_loc_7] = MovieClip(root).teamInfo.wepCount[_loc_7];
                _loc_7++;
            }// end while
            _loc_7 = 0;
            while (_loc_7 <= 5)
            {
                // label
                if (MovieClip(root).teamInfo.unitHealths[_loc_7] > 0)
                {
                    _17c5(setupUnits[_loc_7][0], setupUnits[_loc_7][1], setupUnits[_loc_7][2], false);
                    _17a2[_17a2.length-1].unitName = MovieClip(root).teamInfo.unitNames[_loc_7];
                    _17a2[_17a2.length-1].health = 10 * MovieClip(root).teamInfo.unitHealths[_loc_7];
                    _17a2[_17a2.length-1].accuracy = MovieClip(root).teamInfo.unitAccuracy[_loc_7];
                    _17a2[_17a2.length-1].maxHealth = _17a2[_17a2.length-1].health;
                }// end if
                _loc_7++;
            }// end while
            _loc_7 = 6;
            while (_loc_7 < setupUnits.length)
            {
                // label
                _17c5(setupUnits[_loc_7][0], setupUnits[_loc_7][1], setupUnits[_loc_7][2], false);
                _17a2[_17a2.length-1].health = MovieClip(root).levelSetup.teamHealths[setupUnits[_loc_7][2]--];
                _17a2[_17a2.length-1].accuracy = MovieClip(root).levelSetup.AISkill[setupUnits[_loc_7][2]--];
                _17a2[_17a2.length-1].unitName = setupUnits[_loc_7][3];
                _loc_7++;
            }// end while
            _loc_5 = 0;
            while (_loc_5 < setupMines.length)
            {
                // label
                _1754(setupMines[_loc_5][0], setupMines[_loc_5][1]);
                _mines[_mines.length-1].timeTilPrimed = 0;
                _mines[_mines.length-1].gotoAndStop(2);
                _loc_5++;
            }// end while
            _loc_6 = 0;
            while (_loc_6 < setupShields.length)
            {
                // label
                _17a7(setupShields[_loc_6][0], setupShields[_loc_6][1], setupShields[_loc_6][2]);
                _loc_6++;
            }// end while
            _1774();
            _174a = 0;
            while (_174a < _17a2.length)
            {
                // label
                _1734.addChild(_17a2[_174a].healthDisplay);
                _17a2[_174a].healthDisplay.x = _17a2[_174a].x;
                _17a2[_174a].healthDisplay.y = _17a2[_174a].y;
                _17a2[_174a].healthDisplay.rotation = _17a2[_174a].rotation;
                _17a2[_174a].healthDisplay.updateDisplay(_17a2[_174a].health, _17a2[_174a].team);
                _174a++;
            }// end while
            _loc_7 = 0;
            while (_loc_7 < _17b10)
            {
                // label
                if (_loc_7 == 0)
                {
                    _17a1.push(new TeamDisplayRed());
                    _17a1[_17a1.length-1].teamname.text = MovieClip(root).teamInfo.teamName;
                }
                else if (_loc_7 == 1)
                {
                    _17a1.push(new TeamDisplayBlue());
                    _17a1[_17a1.length-1].teamname.text = MovieClip(root).levelSetup.teamNames[_loc_7--];
                }
                else if (_loc_7 == 2)
                {
                    _17a1.push(new TeamDisplayGreen());
                    _17a1[_17a1.length-1].teamname.text = MovieClip(root).levelSetup.teamNames[_loc_7--];
                }
                else if (_loc_7 == 3)
                {
                    _17a1.push(new TeamDisplayYellow());
                    _17a1[_17a1.length-1].teamname.text = MovieClip(root).levelSetup.teamNames[_loc_7--];
                }// end else if
                _17a1[_17a1.length-1].bar.gotoAndStop(1);
                _17a1[_17a1.length-1].x = 154 * _loc_7 + 10;
                _1735.addChild(_17a1[_17a1.length-1]);
                _loc_7++;
            }// end while
            _177b(true);
            _loc_8 = 0;
            while (_loc_8 < _plantes.length)
            {
                // label
                if (_plantes[_loc_8].x - _plantes[_loc_8].diameter / 2 < _175b)
                {
                    _175b = _plantes[_loc_8].x - _plantes[_loc_8].diameter / 2;
                }// end if
                if (_plantes[_loc_8].x + _plantes[_loc_8].diameter / 2 > _1795)
                {
                    _1795 = _plantes[_loc_8].x + _plantes[_loc_8].diameter / 2;
                }// end if
                if (_plantes[_loc_8].y - _plantes[_loc_8].diameter / 2 < _177c)
                {
                    _177c = _plantes[_loc_8].y - _plantes[_loc_8].diameter / 2;
                }// end if
                if (_plantes[_loc_8].y + _plantes[_loc_8].diameter / 2 > _1797)
                {
                    _1797 = _plantes[_loc_8].y + _plantes[_loc_8].diameter / 2;
                }// end if
                _loc_8++;
            }// end while
            _175b = _175b - 50;
            _177c = _177c - 50;
            _1795 = _1795 + 50;
            _1797 = _1797 + 50;
            _loc_9 = _1795 - _175b;
            _loc_10 = _1797 - _177c;
            if (_loc_9 < 700)
            {
                _175b = _175b - (700 - _loc_9) / 2;
                _1795 = _1795 + (700 - _loc_9) / 2;
            }// end if
            if (_loc_10 < 500)
            {
                _177c = _177c - (500 - _loc_10) / 2;
                _1797 = _1797 + (500 - _loc_10) / 2;
            }// end if
            _loc_9 = _1795 - _175b;
            _loc_10 = _1797 - _177c;
            _loc_11 = 700 / _loc_9;
            _loc_12 = 500 / _loc_10;
            if (_loc_11 < _loc_12)
            {
                _179b = _loc_11;
            }
            else
            {
                _179b = _loc_12;
            }// end else if
            MovieClip(root).msg.addMessage(_17a2[_17be].unitName + "\'s Turn", _17a2[_17be].team);
            _cam.setTarget(_17a2[_17be], _175b, _177c, _1795, _1797);
            return;
        }// end function

        public function _172a(param1:MouseEvent)
        {
            MovieClip(root).explain.gotoAndStop(1);
            return;
        }// end function

        public function _172c(param1:MouseEvent)
        {
            param1.currentTarget.healthDisplay.unitname.text = "";
            return;
        }// end function

        public function _172e(param1:MouseEvent)
        {
            MovieClip(root).explain.gotoAndStop(param1.currentTarget.name.substr(2) * 1 + 1);
            return;
        }// end function

        public function _172f(param1:MouseEvent)
        {
            param1.currentTarget.healthDisplay.x = param1.currentTarget.x;
            param1.currentTarget.healthDisplay.y = param1.currentTarget.y;
            param1.currentTarget.healthDisplay.rotation = param1.currentTarget.rotation;
            param1.currentTarget.healthDisplay.unitname.textColor = _118d[param1.currentTarget.team];
            param1.currentTarget.healthDisplay.unitname.text = param1.currentTarget.unitName;
            return;
        }// end function

        public function doPause(param1:MouseEvent = null)
        {
            MovieClip(root).pausePanel.gotoAndStop(2);
            _177f = true;
            return;
        }// end function

        public function _1733()
        {
            _1791 = 0;
            _179f = "pickupFind";
            _176c = 1;
            _17a3 = 0;
            _1772 = 0;
            _1793 = false;
            _1789 = -1;
            _175f = -1;
            _17ae = new Array();
            _17810 = new Array();
            _178a = 0;
            if (_17a2[_17be].animState.substr(0, 6) != "aiming")
            {
                _17a2[_17be].changeAnim("aiming" + _176c);
            }// end if
            _1778.graphics.clear();
            return;
        }// end function

        public function _1738(param1:Event = null)
        {
            var _loc_2:int;
            removeEventListener(Event.ADDED_TO_STAGE, _1738);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, _1728);
            stage.addEventListener(KeyboardEvent.KEY_UP, _1744);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, _17b1);
            _wepIcon.buttonMode = true;
            _wepIcon.useHandCursor = true;
            _17c3();
            _loc_2 = 1;
            while (_loc_2 < 10)
            {
                // label
                _17610[_loc_2] = MovieClip(root).teamInfo.wepCount[_loc_2];
                _loc_2++;
            }// end while
            _loc_2 = 1;
            while (_loc_2 < 10)
            {
                // label
                _174c[_loc_2] = MovieClip(root).levelSetup.enemyWeps[_loc_2];
                _loc_2++;
            }// end while
            panelWeps.panel.wep1.addEventListener(MouseEvent.MOUSE_UP, _1761);
            panelWeps.panel.qm1.addEventListener(MouseEvent.MOUSE_OVER, _172e);
            panelWeps.panel.qm1.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            if (MovieClip(root).achievementsInfo.wepsUnlocked[2])
            {
                panelWeps.panel.wep2.addEventListener(MouseEvent.MOUSE_UP, _1765);
                panelWeps.panel.qm2.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm2.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[4])
            {
                panelWeps.panel.wep4.addEventListener(MouseEvent.MOUSE_UP, _176d);
                panelWeps.panel.qm3.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm3.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[6])
            {
                panelWeps.panel.wep6.addEventListener(MouseEvent.MOUSE_UP, _1777);
                panelWeps.panel.qm4.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm4.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[8])
            {
                panelWeps.panel.wep8.addEventListener(MouseEvent.MOUSE_UP, _178f);
                panelWeps.panel.qm5.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm5.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[9])
            {
                panelWeps.panel.wep9.addEventListener(MouseEvent.MOUSE_UP, _176b);
                panelWeps.panel.qm6.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm6.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[5])
            {
                panelWeps.panel.wep5.addEventListener(MouseEvent.MOUSE_UP, _176e);
                panelWeps.panel.qm7.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm7.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[10])
            {
                panelWeps.panel.wep10.addEventListener(MouseEvent.MOUSE_UP, _173e);
                panelWeps.panel.qm8.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm8.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[7])
            {
                panelWeps.panel.wep7.addEventListener(MouseEvent.MOUSE_UP, _1769);
                panelWeps.panel.qm9.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm9.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[3])
            {
                panelWeps.panel.wep3.addEventListener(MouseEvent.MOUSE_UP, _1762);
                panelWeps.panel.qm10.addEventListener(MouseEvent.MOUSE_OVER, _172e);
                panelWeps.panel.qm10.addEventListener(MouseEvent.MOUSE_OUT, _172a);
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[2])
            {
                panelWeps.panel.wep1lock.gotoAndStop(2);
                panelWeps.panel.qm2.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[4])
            {
                panelWeps.panel.wep2lock.gotoAndStop(2);
                panelWeps.panel.qm3.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[6])
            {
                panelWeps.panel.wep3lock.gotoAndStop(2);
                panelWeps.panel.qm4.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[8])
            {
                panelWeps.panel.wep4lock.gotoAndStop(2);
                panelWeps.panel.qm5.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[9])
            {
                panelWeps.panel.wep5lock.gotoAndStop(2);
                panelWeps.panel.qm6.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[5])
            {
                panelWeps.panel.wep6lock.gotoAndStop(2);
                panelWeps.panel.qm7.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[10])
            {
                panelWeps.panel.wep7lock.gotoAndStop(2);
                panelWeps.panel.qm8.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[7])
            {
                panelWeps.panel.wep8lock.gotoAndStop(2);
                panelWeps.panel.qm9.alpha = 0;
            }// end if
            if (!MovieClip(root).achievementsInfo.wepsUnlocked[3])
            {
                panelWeps.panel.wep9lock.gotoAndStop(2);
                panelWeps.panel.qm10.alpha = 0;
            }// end if
            _17ba();
            if (MovieClip(root).levelSetup.levelID > 2)
            {
                _17c6.cndtext.alpha = 0;
            }// end if
            setupPlanets = MovieClip(root).levelSetup.setupPlanets;
            setupUnits = MovieClip(root).levelSetup.setupUnits;
            setupMines = MovieClip(root).levelSetup.setupMines;
            setupShields = MovieClip(root).levelSetup.setupShields;
            _1729();
            if (MovieClip(root).levelSetup.levelID == 1 && !MovieClip(root).tutorialsDone[0])
            {
                MovieClip(root).tutorialsDone[0] = true;
                MovieClip(root).showTutorial(0, 121, 97);
                gameTimer.pauseTime = true;
            }
            else if (MovieClip(root).levelSetup.levelID == 2 && !MovieClip(root).tutorialsDone[1])
            {
                MovieClip(root).tutorialsDone[1] = true;
                MovieClip(root).showTutorial(1, 121, 97);
                gameTimer.pauseTime = true;
            }
            else if (MovieClip(root).levelSetup.levelID == 3 && !MovieClip(root).tutorialsDone[5])
            {
                MovieClip(root).tutorialsDone[5] = true;
                MovieClip(root).showTutorial(5, 121, 97);
                gameTimer.pauseTime = true;
            }
            else if (MovieClip(root).levelSetup.levelID == 7 && !MovieClip(root).tutorialsDone[2])
            {
                MovieClip(root).tutorialsDone[2] = true;
                MovieClip(root).showTutorial(2, 121, 97);
                gameTimer.pauseTime = true;
            }
            else if (MovieClip(root).levelSetup.levelID == 8 && !MovieClip(root).tutorialsDone[3])
            {
                MovieClip(root).tutorialsDone[3] = true;
                MovieClip(root).showTutorial(3, 121, 97);
                gameTimer.pauseTime = true;
            }// end else if
            return;
        }// end function

        public function _1739(param1:MouseEvent = null)
        {
            if (panelWeps.currentFrame == 1)
            {
                panelWeps.removeEventListener(MouseEvent.MOUSE_UP, _1739);
                panelWeps.addEventListener(MouseEvent.MOUSE_UP, _17c1);
                panelWeps.gotoAndPlay(2);
            }// end if
            return;
        }// end function

        public function _173a(param1)
        {
            var _loc_2:int;
            _loc_2 = _17a2.indexOf(param1);
            _1734.removeChild(param1);
            _17a2.splice(_loc_2, 1);
            return;
        }// end function

        public function _173b(param1)
        {
            var _loc_2:int;
            _loc_2 = _17a6.indexOf(param1);
            _173c.removeChild(param1);
            _17a6.splice(_loc_2, 1);
            return;
        }// end function

        public function mainLoop(e:Event)
        {
            var _loc_2:Boolean;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:int;
            var _loc_12:Rectangle;
            var _loc_13:Boolean;
            var _loc_14:int;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:Number;
            var _loc_18:Number;
            var _loc_19:Number;
            var _loc_20:Boolean;
            var _loc_21:*;
            var _loc_22:*;
            var _loc_23:*;
            var _loc_24:int;
            var _loc_25:MovieClip;
            var _loc_26:Matrix;
            var _loc_27:*;
            var _loc_28:*;
            var _loc_29:Number;
            var _loc_30:Number;
            var _loc_31:Number;
            var _loc_32:*;
            var _loc_33:*;
            var _loc_34:*;
            var _loc_35:*;
            var _loc_36:*;
            var _loc_37:*;
            var _loc_38:*;
            var _loc_39:*;
            var _loc_40:*;
            var _loc_41:*;
            var _loc_42:*;
            var _loc_43:*;
            var _loc_44:int;
            var _loc_45:int;
            var _loc_46:Point;
            var _loc_47:Point;
            var _loc_48:Point;
            var _loc_49:Point;
            var _loc_50:*;
            var _loc_51:Point;
            var _loc_52:Point;
            var _loc_53:Point;
            var _loc_54:Point;
            var _loc_55:Point;
            var _loc_56:Array;
            var _loc_57:*;
            var _loc_58:Number;
            var _loc_59:Number;
            var _loc_60:Number;
            var _loc_61:Number;
            var _loc_62:Number;
            var _loc_63:Number;
            var _loc_64:Number;
            var _loc_65:*;
            var _loc_66:*;
            var _loc_67:int;
            var _loc_68:*;
            var _loc_69:int;
            var _loc_70:int;
            var _loc_71:*;
            var _loc_72:*;
            var _loc_73:*;
            var _loc_74:*;
            var _loc_75:*;
            var _loc_76:*;
            var _loc_77:Number;
            var _loc_78:Number;
            var _loc_79:*;
            var _loc_80:Point;
            var _loc_81:*;
            var _loc_82:*;
            var _loc_83:Array;
            var _loc_84:int;
            var _loc_85:*;
            var _loc_86:int;
            var _loc_87:int;
            var _loc_88:int;
            var _loc_89:*;
            var _loc_90:Number;
            var _loc_91:Number;
            var _loc_92:Number;
            var _loc_93:*;
            var _loc_94:*;
            var _loc_95:*;
            var _loc_96:*;
            var _loc_97:*;
            var _loc_98:*;
            var _loc_99:*;
            var _loc_100:*;
            var _loc_101:*;
            var _loc_102:*;
            var _loc_103:*;
            var _loc_104:*;
            var _loc_105:*;
            var _loc_106:*;
            var _loc_107:*;
            var _loc_108:*;
            var _loc_109:Number;
            var _loc_110:int;
            var _loc_111:Boolean;
            var _loc_112:int;
            var _loc_113:*;
            var _loc_114:int;
            if (!_177f)
            {
                gameTimer.updateTimer();
                debugLayer.graphics.clear();
                if (_17a2[_17be] && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                {
                    _17a2[_17be].isWalking = false;
                }// end if
                _loc_2 = false;
                _loc_3 = 0;
                while (_loc_3 < _1763.length)
                {
                    // label
                    if (_1763[_loc_3] == 37 || _1763[_loc_3] == 38 || _1763[_loc_3] == 39 || _1763[_loc_3] == 40 || _1763[_loc_3] == 73 || _1763[_loc_3] == 74 || _1763[_loc_3] == 75 || _1763[_loc_3] == 76)
                    {
                        _loc_2 = true;
                    }// end if
                    _loc_3++;
                }// end while
                if (true)
                {
                    _1727 = "";
                }// end if
                _loc_3 = 0;
                while (_loc_3 < _1763.length)
                {
                    // label
                    if (_1763[_loc_3] == 65)
                    {
                        _cam.targetX = _cam.targetX + 10;
                    }
                    else if (_1763[_loc_3] == 68)
                    {
                        _cam.targetX = _cam.targetX - 10;
                    }
                    else if (_1763[_loc_3] == 87)
                    {
                        _cam.targetY = _cam.targetY + 10;
                    }
                    else if (_1763[_loc_3] == 83)
                    {
                        _cam.targetY = _cam.targetY - 10;
                    }
                    else if (_1727 == "" && _1763[_loc_3] == 37 || _1763[_loc_3] == 74 && !aiming && _17a2[_17be].animState.substr(0, 8) != "teleport" && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                    {
                        if (_17a2[_17be].rotation >= -90 && _17a2[_17be].rotation < 90)
                        {
                            _1727 = "l";
                        }
                        else
                        {
                            _1727 = "r";
                        }// end else if
                    }
                    else if (_1727 == "" && _1763[_loc_3] == 39 || _1763[_loc_3] == 76 && !aiming && _17a2[_17be].animState.substr(0, 8) != "teleport" && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                    {
                        if (_17a2[_17be].rotation >= -90 && _17a2[_17be].rotation < 90)
                        {
                            _1727 = "r";
                        }
                        else
                        {
                            _1727 = "l";
                        }// end else if
                    }
                    else if (_1727 == "" && _1763[_loc_3] == 38 || _1763[_loc_3] == 73 && !aiming && _17a2[_17be].animState.substr(0, 8) != "teleport" && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                    {
                        if (_17a2[_17be].rotation >= 0 && _17a2[_17be].rotation < 180)
                        {
                            _1727 = "l";
                        }
                        else
                        {
                            _1727 = "r";
                        }// end else if
                    }
                    else if (_1727 == "" && _1763[_loc_3] == 40 || _1763[_loc_3] == 75 && !aiming && _17a2[_17be].animState.substr(0, 8) != "teleport" && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                    {
                        if (_17a2[_17be].rotation >= 0 && _17a2[_17be].rotation < 180)
                        {
                            _1727 = "r";
                        }
                        else
                        {
                            _1727 = "l";
                        }// end else if
                    }// end else if
                    _loc_3++;
                }// end while
                if (_1727 == "l" && myTeamsTurn && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                {
                    _17c6.gotoAndStop(34);
                    _17cb(_17be, 3);
                }
                else if (_1727 == "r" && myTeamsTurn && _17210 == "shoot" || _17210 == "sim" && gameTimer.timeLeft > 0)
                {
                    _17c6.gotoAndStop(34);
                    _17c4(_17be, 3);
                }// end else if
                if (!myTeamsTurn && _17210 != "gameover")
                {
                    _17cd();
                }// end if
                _loc_4 = 0;
                while (_loc_4 < _177d.length)
                {
                    // label
                    _177d[_loc_4].mainLoop();
                    if (_177d[_loc_4].timeTilSpit == 0)
                    {
                        if (MovieClip(root).sfx)
                        {
                            MovieClip(root).soundmanager.sound_spit.gotoAndPlay(2);
                        }// end if
                        _loc_15 = Math.random() / 10 + 1;
                        _loc_16 = Math.random() / 10 + 1;
                        _17910(_177d[_loc_4].x, _177d[_loc_4].y, _177d[_loc_4].powerX * _loc_15, _177d[_loc_4].powerY * _loc_16, 0, "aster", null);
                    }// end if
                    _loc_4++;
                }// end while
                _174a = 0;
                while (_174a < _17a2.length)
                {
                    // label
                    _loc_10 = 0;
                    while (_loc_10 < _17a6.length)
                    {
                        // label
                        _loc_17 = _17a6[_loc_10].x - _17a2[_174a].x;
                        _loc_18 = _17a6[_loc_10].y - _17a2[_174a].y;
                        _loc_19 = _loc_17 * _loc_17 + _loc_18 * _loc_18;
                        if (_loc_19 < 400 && !_17a6[_loc_10].removeMe)
                        {
                            if (_179f == "pickup" && _174a == _17be)
                            {
                                _1772--;
                            }// end if
                            _17a6[_loc_10].removeMe = true;
                            if (_17a6[_loc_10] is PickupHealth)
                            {
                                _17a2[_174a].health = _17a2[_174a].health + 25;
                                _17a2[_174a].healthShown = _17a2[_174a].healthShown + 25;
                                MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Health Pack", _17a2[_174a].team);
                                _17a2[_174a].healthDisplay.updateDisplay(_17a2[_174a].health, _17a2[_174a].team);
                                _1784.push(new HealthFloat());
                                _1734.addChild(_1784[_1784.length-1]);
                                _1784[_1784.length-1].updateDisplay(25, _17a2[_174a].team, true);
                                _1784[_1784.length-1].x = _17a2[_174a].x;
                                _1784[_1784.length-1].y = _17a2[_174a].y;
                                _1784[_1784.length-1].rotation = _17a2[_174a].rotation;
                                if (_17a2[_174a].poisoned)
                                {
                                    _17a2[_174a].poisoned = false;
                                    _17a2[_174a].poison.gotoAndStop(1);
                                }// end if
                                if (MovieClip(root).sfx)
                                {
                                    MovieClip(root).soundmanager.sound_pickuphealth.gotoAndPlay(2);
                                }// end if
                            }
                            else if (_17a6[_loc_10] is PickupWeapon)
                            {
                                _loc_20 = false;
                                if (MovieClip(root).sfx)
                                {
                                    MovieClip(root).soundmanager.sound_pickupammo.gotoAndPlay(2);
                                }// end if
                                do
                                {
                                    // label
                                    _loc_21 = Math.floor(Math.random() * 65);
                                    if (_loc_21 < 10 && MovieClip(root).achievementsInfo.wepsUnlocked[2])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[1]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Cluster Rocket", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[1]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 16 && MovieClip(root).achievementsInfo.wepsUnlocked[4])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[2]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Sniper Rifle", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[2]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 26 && MovieClip(root).achievementsInfo.wepsUnlocked[6])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[3]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Poisoned Dart", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[3]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 36 && MovieClip(root).achievementsInfo.wepsUnlocked[8])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[4]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Land Mine", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[4]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 42 && MovieClip(root).achievementsInfo.wepsUnlocked[9])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[5]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Shield", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[5]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 50 && MovieClip(root).achievementsInfo.wepsUnlocked[5])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[6]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Drill Bomb", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[6]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 60 && MovieClip(root).achievementsInfo.wepsUnlocked[10])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[7]++;
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Teleport", _17a2[_174a].team);
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[7]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 63 && MovieClip(root).achievementsInfo.wepsUnlocked[7])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Nuke", _17a2[_174a].team);
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[8]++;
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[8]++;
                                        }// end else if
                                        _loc_20 = true;
                                        continue;
                                    }// end if
                                    if (_loc_21 < 65 && MovieClip(root).achievementsInfo.wepsUnlocked[3])
                                    {
                                        if (_17a2[_174a].team == 0)
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " found a Meteor Shower", _17a2[_174a].team);
                                            var _loc_115:* = _17610;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _17610[9]++;
                                        }
                                        else
                                        {
                                            MovieClip(root).msg.addMessage(_17a2[_174a].unitName + " collected a Weapon", _17a2[_174a].team);
                                            var _loc_115:* = _174c;
                                            var _loc_116:int;
                                            _loc_115[_loc_116] = _174c[9]++;
                                        }// end else if
                                        _loc_20 = true;
                                    }// end if
                                }while (!_loc_20)
                                _17ba();
                            }// end if
                        }// end else if
                        _loc_10++;
                    }// end while
                    _174a++;
                }// end while
                _loc_5 = 0;
                while (_loc_5 < _projectileArr.length)
                {
                    // label
                    if (_projectileArr[_loc_5] is MineProjectile)
                    {
                        if (_projectileArr[_loc_5].intDelay <= 0)
                        {
                            _projectileArr[_loc_5].doGravity(_plantes);
                        }// end if
                    }
                    else if (_projectileArr[_loc_5] is Wep2aProjectile)
                    {
                        _projectileArr[_loc_5].doGravity(new Array(_plantes[_projectileArr[_loc_5].onlyPlanet]));
                    }
                    else if (!(_projectileArr[_loc_5] is Wep5Projectile && _projectileArr[_loc_5].inPlanet > 0))
                    {
                        _projectileArr[_loc_5].doGravity(_plantes);
                    }// end else if
                    _projectileArr[_loc_5].moveProjectile(_175b, _1795, _177c, _1797);
                    if (_projectileArr[_loc_5] is Wep5Projectile && _projectileArr[_loc_5].inPlanet > 0)
                    {
                        _loc_22 = _projectileArr[_loc_5].x - _plantes[_projectileArr[_loc_5].planetHit].x;
                        _loc_23 = _projectileArr[_loc_5].y - _plantes[_projectileArr[_loc_5].planetHit].y;
                        _loc_24 = 8;
                        _loc_25 = new MovieClip();
                        _loc_25.graphics.beginFill(0, 0.1);
                        _loc_25.graphics.drawCircle(_loc_24, _loc_24, _loc_24);
                        _loc_25.graphics.endFill();
                        _loc_26 = new Matrix();
                        _loc_26.translate(_loc_22 + _plantes[_projectileArr[_loc_5].planetHit].diameter / 2 - _loc_24, _loc_23 + _plantes[_projectileArr[_loc_5].planetHit].diameter / 2 - _loc_24);
                        _plantes[_projectileArr[_loc_5].planetHit].BMData.draw(_loc_25, _loc_26, null, null, null, false);
                    }// end if
                    if (_projectileArr[_loc_5].hasSmoke)
                    {
                        _loc_27 = _projectileArr[_loc_5].x + 4 * Math.sin(Math.PI / 2 - _projectileArr[_loc_5].rotation * (Math.PI / 180));
                        _loc_28 = _projectileArr[_loc_5].y + 4 * Math.cos(Math.PI / 2 - _projectileArr[_loc_5].rotation * (Math.PI / 180));
                        _loc_29 = Math.cos(Math.PI / 2 - _projectileArr[_loc_5].rotation * (Math.PI / 180));
                        _loc_30 = Math.sin(Math.PI / 2 - _projectileArr[_loc_5].rotation * (Math.PI / 180));
                        _loc_31 = Math.random() * 4 - 2;
                        _loc_32 = _loc_31 * _loc_29;
                        _loc_33 = _loc_31 * _loc_30;
                        if (_projectileArr[_loc_5].lastSmokeX && _projectileArr[_loc_5].lastSmokeY)
                        {
                            _loc_34 = _loc_27 - _projectileArr[_loc_5].lastSmokeX;
                            _loc_35 = _loc_28 - _projectileArr[_loc_5].lastSmokeY;
                            _loc_36 = Math.sqrt(_loc_34 * _loc_34 + _loc_35 * _loc_35);
                            _loc_37 = Math.ceil(_loc_36 / 1.5);
                            _loc_38 = _loc_34 / _loc_37;
                            _loc_39 = _loc_35 / _loc_37;
                            _loc_6 = 1;
                            while (_loc_6 < _loc_37)
                            {
                                // label
                                _loc_31 = Math.random() * 4 - 2;
                                _loc_40 = _loc_31 * _loc_29;
                                _loc_41 = _loc_31 * _loc_30;
                                _loc_42 = _projectileArr[_loc_5].lastSmokeX + _loc_38 * _loc_6;
                                _loc_43 = _projectileArr[_loc_5].lastSmokeY + _loc_39 * _loc_6;
                                _175d.push(new Particle(_loc_42 + _loc_40, _loc_43 + _loc_41, 0, 0, _projectileArr[_loc_5].smokeType, _projectileArr[_loc_5].smokeLife));
                                _loc_6++;
                            }// end while
                        }// end if
                        _projectileArr[_loc_5].lastSmokeX = _loc_27;
                        _projectileArr[_loc_5].lastSmokeY = _loc_28;
                        _175d.push(new Particle(_loc_27 + _loc_32, _loc_28 + _loc_33, 0, 0, _projectileArr[_loc_5].smokeType, _projectileArr[_loc_5].smokeLife));
                    }// end if
                    if (_loc_5 == 0)
                    {
                        _cam.setTarget(_projectileArr[_loc_5], _175b, _177c, _1795, _1797);
                    }// end if
                    _loc_5++;
                }// end while
                if (_projectileArr.length == 0 && _17210 != "shoot")
                {
                    _loc_44 = -1;
                    _loc_45 = 0;
                    while (_loc_45 < _17a2.length)
                    {
                        // label
                        if (_17a2[_loc_45].animState == "lay" && _loc_44 == -1)
                        {
                            _loc_44 = _loc_45;
                        }// end if
                        _loc_45++;
                    }// end while
                    if (_loc_44 > -1)
                    {
                        _cam.setTarget(_17a2[_loc_45], _175b, _177c, _1795, _1797);
                    }
                    else if (_17a2[_17be])
                    {
                        _cam.setTarget(_17a2[_17be], _175b, _177c, _1795, _1797);
                    }
                    else
                    {
                        _cam.setTarget(_17a2[0], _175b, _177c, _1795, _1797);
                    }// end else if
                }// end else if
                _loc_6 = 0;
                while (_loc_6 < _1737.length)
                {
                    // label
                    if (_1737[_loc_6 + 1])
                    {
                        _loc_46 = new Point(_1737[_loc_6].x, _1737[_loc_6].y);
                        _loc_47 = new Point(_1737[_loc_6 + 1].x, _1737[_loc_6 + 1].y);
                        _loc_5 = 0;
                        while (_loc_5 < _projectileArr.length)
                        {
                            // label
                            _loc_48 = new Point(_projectileArr[_loc_5].x, _projectileArr[_loc_5].y);
                            _loc_49 = new Point(_projectileArr[_loc_5].oldX, _projectileArr[_loc_5].oldY);
                            _loc_50 = lineIntersectLine(_loc_46, _loc_47, _loc_48, _loc_49, true);
                            if (!_projectileArr[_loc_5].removeMe && _loc_50 && _projectileArr[_loc_5].shieldDelay <= 0)
                            {
                                if (_projectileArr[_loc_5] is UnitProjectile)
                                {
                                    _projectileArr[_loc_5].removeMe = true;
                                    _17b7(_loc_50.x, _loc_50.y, 1, "zap");
                                    _17ce[_17ce.length-1].team = _projectileArr[_loc_5].team;
                                    _17ce[_17ce.length-1].gotoAndPlay(2);
                                    _17ce[_17ce.length-1].rotation = _projectileArr[_loc_5].rotation;
                                    if (myTeamsTurn)
                                    {
                                        if (_projectileArr[_loc_5].team != 0)
                                        {
                                            if (_projectileArr[_loc_5].killReg > 0)
                                            {
                                                var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                                var _loc_116:* = "wep" + _projectileArr[_loc_5].killReg + "Kills";
                                                _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["wep" + _projectileArr[_loc_5].killReg + "Kills"]++;
                                            }// end if
                                            var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                            var _loc_116:String;
                                            _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["enemiesShield"]++;
                                            var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                            var _loc_116:String;
                                            _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["enemyKills"]++;
                                        }// end if
                                    }// end if
                                    if (_projectileArr[_loc_5].team == 0)
                                    {
                                        var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                        var _loc_116:String;
                                        _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["friendlyKills"]++;
                                    }// end if
                                    _1737[_loc_6].timeTilDie = 25;
                                    _1737[_loc_6 + 1].timeTilDie = 25;
                                }
                                else
                                {
                                    _loc_27 = _loc_50.x;
                                    _loc_28 = _loc_50.y;
                                    _loc_51 = new Point(_projectileArr[_loc_5].momX, _projectileArr[_loc_5].momY);
                                    _loc_52 = new Point(_loc_46.x, _loc_46.y);
                                    _loc_53 = new Point(_loc_47.x, _loc_47.y);
                                    _loc_54 = new Point(_loc_48.x, _loc_48.y);
                                    _loc_55 = new Point(_loc_49.x, _loc_49.y);
                                    _loc_56 = _1792(_loc_52, _loc_53, _loc_54, _loc_55, _loc_51, 1);
                                    _projectileArr[_loc_5].reflected = true;
                                    _projectileArr[_loc_5].shieldDelay = 2;
                                    _projectileArr[_loc_5].x = _loc_27;
                                    _projectileArr[_loc_5].y = _loc_28;
                                    _17b7(_loc_27, _loc_28, 1, "spark");
                                    _projectileArr[_loc_5].momX = _loc_56[1].x;
                                    _projectileArr[_loc_5].momY = _loc_56[1].y;
                                    _1737[_loc_6].timeTilDie = 5;
                                    _1737[_loc_6 + 1].timeTilDie = 5;
                                }// end else if
                                var _loc_115:* = _1737[_loc_6 + 1];
                                _loc_115.life = _1737[_loc_6 + 1].life--;
                                var _loc_115:* = _1737[_loc_6];
                                _loc_115.life = _1737[_loc_6].life--;
                            }// end if
                            _loc_5++;
                        }// end while
                    }// end if
                    _loc_6 = _loc_6 + 2;
                }// end while
                _loc_5 = 0;
                while (_loc_5 < _projectileArr.length)
                {
                    // label
                    _174a = 0;
                    while (_174a < _17a2.length)
                    {
                        // label
                        if (!_17a2[_174a].removeMe && !_projectileArr[_loc_5].removeMe && !(_projectileArr[_loc_5] is UnitProjectile) && !(_projectileArr[_loc_5] is MineProjectile) && _174a != _17be || _projectileArr[_loc_5].life > 5)
                        {
                            _loc_57 = _17b2(_17a2[_174a], _projectileArr[_loc_5]);
                            if (_loc_57 && !(_projectileArr[_loc_5] is Wep6Projectile))
                            {
                                _loc_58 = _projectileArr[_loc_5].x;
                                _loc_59 = _projectileArr[_loc_5].y;
                                _loc_60 = _projectileArr[_loc_5].oldX;
                                _loc_61 = _projectileArr[_loc_5].oldY;
                                _loc_64 = 10;
                                _loc_62 = (_loc_58 + _loc_60) / 2;
                                _loc_63 = (_loc_59 + _loc_61) / 2;
                                _loc_65 = _projectileArr[_loc_5].x - _projectileArr[_loc_5].oldX;
                                _loc_66 = _projectileArr[_loc_5].y - _projectileArr[_loc_5].oldY;
                                _projectileArr[_loc_5].x = _loc_62;
                                _projectileArr[_loc_5].y = _loc_63;
                                while (_loc_67-- >= 0)
                                {
                                    // label
                                    removeChild(_1743[_1743.length-1]);
                                    _1743.splice(_loc_67, 1);
                                }// end while
                                while (_loc_64 > 0.01)
                                {
                                    // label
                                    _loc_73 = PixelPerfectCollisionDetection.isColliding(_17a2[_174a].hitarea, _projectileArr[_loc_5], this, true, 0);
                                    if (_loc_73)
                                    {
                                        _loc_57 = _loc_73;
                                        _loc_58 = _loc_62;
                                        _loc_59 = _loc_63;
                                    }
                                    else
                                    {
                                        _loc_60 = _loc_62;
                                        _loc_61 = _loc_63;
                                    }// end else if
                                    _loc_62 = (_loc_58 + _loc_60) / 2;
                                    _loc_63 = (_loc_59 + _loc_61) / 2;
                                    _projectileArr[_loc_5].x = _loc_62;
                                    _projectileArr[_loc_5].y = _loc_63;
                                    _loc_64 = (_loc_62 - _loc_58) * (_loc_62 - _loc_58) + (_loc_63 - _loc_59) * (_loc_63 - _loc_59);
                                }// end while
                                _projectileArr[_loc_5].x = _loc_58;
                                _projectileArr[_loc_5].y = _loc_59;
                                _projectileArr[_loc_5].removeMe = true;
                                if (_174a == _17be && _17210 == "sim" && gameTimer.timeLeft > 0)
                                {
                                    gameTimer.timeLeft = 0;
                                }// end if
                                _17a2[_174a].removeMe = true;
                                if (_projectileArr[_loc_5] is Wep2Projectile)
                                {
                                    shake = 3;
                                    if (_projectileArr[_loc_5] is Wep2Projectile)
                                    {
                                        _loc_68 = Math.atan2(_projectileArr[_loc_5].y - _projectileArr[_loc_5].oldY, _projectileArr[_loc_5].x - _projectileArr[_loc_5].oldX);
                                        _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.35), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.2), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.2), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.2), 0, "payload", _17a2[_174a].positionPlanet);
                                        _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.35), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.35), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.35), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.35), 0, "payload", _17a2[_174a].positionPlanet);
                                        _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.5), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.5), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.5), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.5), 0, "payload", _17a2[_174a].positionPlanet);
                                        _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.65), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.65), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.65), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.65), 0, "payload", _17a2[_174a].positionPlanet);
                                        _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.65), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.8), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.8), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.8), 0, "payload", _17a2[_174a].positionPlanet);
                                    }// end if
                                }
                                else if (_projectileArr[_loc_5] is Wep7Projectile)
                                {
                                    _loc_69 = 0;
                                    while (_loc_69 < _17a2.length)
                                    {
                                        // label
                                        if (_17a2[_loc_69].positionPlanet == _17a2[_174a].positionPlanet)
                                        {
                                            _17a2[_loc_69].poisoned = true;
                                            _17a2[_loc_69].poison.gotoAndPlay(2);
                                        }// end if
                                        _loc_69++;
                                    }// end while
                                }// end else if
                                _17a2[_174a].removeMe = false;
                                _17ca(_projectileArr[_loc_5].x, _projectileArr[_loc_5].y, _loc_5, -1, "unit");
                            }
                            else if (_loc_57 && _projectileArr[_loc_5] is Wep6Projectile)
                            {
                                _projectileArr[_loc_5].removeMe = true;
                                _17a2[_174a].poisoned = true;
                                _17a2[_174a].poison.gotoAndPlay(2);
                                _17a2[_174a].changeAnim("falldown");
                                if (_17a2[_174a].killReg == -1 && _17a2[_174a].health <= _projectileArr[_loc_5].maxDamage * _projectileArr[_loc_5].multi)
                                {
                                    _17a2[_174a].killReg = 6;
                                }// end if
                                _17a2[_174a].damageTaken = _17a2[_174a].damageTaken + _projectileArr[_loc_5].maxDamage * _projectileArr[_loc_5].multi;
                                if (_17a2[_174a].team != 0 && myTeamsTurn)
                                {
                                    _1794 = _1794 + _projectileArr[_loc_5].maxDamage * _projectileArr[_loc_5].multi;
                                }// end if
                            }// end if
                        }// end else if
                        _174a++;
                    }// end while
                    _loc_5++;
                }// end while
                _loc_5 = 0;
                while (_loc_5 < _projectileArr.length)
                {
                    // label
                    _loc_70 = _loc_5 + 1;
                    while (_loc_70 < _projectileArr.length)
                    {
                        // label
                        if (!_projectileArr[_loc_5].removeMe && !_projectileArr[_loc_70].removeMe && _loc_5 != _loc_70)
                        {
                            if (_projectileArr[_loc_5] is UnitProjectile && !(_projectileArr[_loc_70] is UnitProjectile) || _projectileArr[_loc_70] is UnitProjectile && !(_projectileArr[_loc_5] is UnitProjectile) && !(_projectileArr[_loc_5] is Wep5Projectile) && !(_projectileArr[_loc_70] is Wep5Projectile))
                            {
                                if (_174d(_projectileArr[_loc_5], _projectileArr[_loc_70]))
                                {
                                    if (_projectileArr[_loc_5] is UnitProjectile)
                                    {
                                        _loc_71 = _loc_70;
                                        _loc_72 = _loc_5;
                                    }
                                    else if (_projectileArr[_loc_70] is UnitProjectile)
                                    {
                                        _loc_71 = _loc_5;
                                        _loc_72 = _loc_70;
                                    }// end else if
                                    _projectileArr[_loc_71].removeMe = true;
                                    _17ca(_projectileArr[_loc_71].x, _projectileArr[_loc_71].y, _loc_71, -1, "proj");
                                    _projectileArr[_loc_72].damageTaken = _projectileArr[_loc_72].damageTaken + _projectileArr[_loc_71].maxDamage * _projectileArr[_loc_71].multi;
                                }// end if
                            }// end if
                        }// end if
                        _loc_70++;
                    }// end while
                    _loc_5++;
                }// end while
                _loc_5 = 0;
                while (_loc_5 < _projectileArr.length)
                {
                    // label
                    if (!_projectileArr[_loc_5].removeMe)
                    {
                        _1725 = 0;
                        while (_1725 < _plantes.length)
                        {
                            // label
                            _loc_73 = false;
                            _loc_57 = _17b9(_plantes[_1725], _projectileArr[_loc_5]);
                            if (_loc_57)
                            {
                                if (!(_projectileArr[_loc_5] is Wep5Projectile) || _projectileArr[_loc_5] is Wep5Projectile && _projectileArr[_loc_5].inPlanet == 0)
                                {
                                    if (_projectileArr[_loc_5] is Wep5Projectile)
                                    {
                                        _projectileArr[_loc_5].hasSmoke = false;
                                        _projectileArr[_loc_5].inPlanet = 1;
                                        _projectileArr[_loc_5].planetHit = _1725;
                                        _loc_74 = Math.sqrt(_projectileArr[_loc_5].momX * _projectileArr[_loc_5].momX + _projectileArr[_loc_5].momY * _projectileArr[_loc_5].momY);
                                        _loc_75 = 3;
                                        _loc_76 = _loc_75 / _loc_74;
                                        _projectileArr[_loc_5].momX = _projectileArr[_loc_5].momX * _loc_76;
                                        _projectileArr[_loc_5].momY = _projectileArr[_loc_5].momY * _loc_76;
                                    }
                                    else
                                    {
                                        _loc_46 = new Point(_loc_57.x + _loc_57.width / 2 - _plantes[_1725].x, _loc_57.y + _loc_57.height / 2 - _plantes[_1725].y);
                                        _loc_58 = _projectileArr[_loc_5].x;
                                        _loc_59 = _projectileArr[_loc_5].y;
                                        _loc_77 = _projectileArr[_loc_5].x;
                                        _loc_78 = _projectileArr[_loc_5].y;
                                        _loc_60 = _projectileArr[_loc_5].oldX;
                                        _loc_61 = _projectileArr[_loc_5].oldY;
                                        _loc_64 = 10;
                                        _loc_62 = (_loc_58 + _loc_60) / 2;
                                        _loc_63 = (_loc_59 + _loc_61) / 2;
                                        _projectileArr[_loc_5].x = _loc_62;
                                        _projectileArr[_loc_5].y = _loc_63;
                                        while (_loc_67-- >= 0)
                                        {
                                            // label
                                            removeChild(_1743[_1743.length-1]);
                                            _1743.splice(_loc_67, 1);
                                        }// end while
                                        while (_loc_64 > 0.01)
                                        {
                                            // label
                                            _loc_73 = _17b9(_plantes[_1725], _projectileArr[_loc_5]);
                                            if (_loc_73)
                                            {
                                                _loc_57 = _loc_73;
                                                _loc_58 = _loc_62;
                                                _loc_59 = _loc_63;
                                            }
                                            else
                                            {
                                                _loc_60 = _loc_62;
                                                _loc_61 = _loc_63;
                                            }// end else if
                                            _loc_62 = (_loc_58 + _loc_60) / 2;
                                            _loc_63 = (_loc_59 + _loc_61) / 2;
                                            _projectileArr[_loc_5].x = _loc_62;
                                            _projectileArr[_loc_5].y = _loc_63;
                                            _loc_64 = (_loc_62 - _loc_58) * (_loc_62 - _loc_58) + (_loc_63 - _loc_59) * (_loc_63 - _loc_59);
                                        }// end while
                                        if (!(_projectileArr[_loc_5] is MineProjectile))
                                        {
                                            _projectileArr[_loc_5].x = _loc_58;
                                            _projectileArr[_loc_5].y = _loc_59;
                                        }
                                        else
                                        {
                                            _projectileArr[_loc_5].x = _loc_77;
                                            _projectileArr[_loc_5].y = _loc_78;
                                        }// end if
                                    }// end else if
                                }// end else if
                                if (_projectileArr[_loc_5] is MineProjectile)
                                {
                                    if (!_plantes[_1725].isSun)
                                    {
                                        _loc_47 = new Point(_projectileArr[_loc_5].oldX - _plantes[_1725].x, _projectileArr[_loc_5].oldY - _plantes[_1725].y);
                                        _loc_80 = new Point(_loc_46.x - _loc_47.x + _loc_46.x, _loc_46.y - _loc_47.y + _loc_46.y);
                                        _loc_83 = new Array();
                                        _loc_84 = 0;
                                        _loc_85 = 5000;
                                        _loc_86 = -1;
                                        _loc_87 = -1;
                                        _loc_88 = -1;
                                        _loc_6 = 0;
                                        while (_loc_6 < _plantes[_1725].shapeArray.length)
                                        {
                                            // label
                                            _loc_10 = 0;
                                            while (_loc_10 < _plantes[_1725].shapeArray[_loc_6].length)
                                            {
                                                // label
                                                _loc_48 = new Point(_plantes[_1725].shapeArray[_loc_6][_loc_10].x, _plantes[_1725].shapeArray[_loc_6][_loc_10].y);
                                                _loc_49 = new Point(_plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].x, _plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].y);
                                                _loc_89 = _plantes[_1725].lineIntersectLine(_loc_47, _loc_80, _loc_48, _loc_49, true);
                                                if (_loc_89)
                                                {
                                                    _projectileArr[_loc_5].intDelay = 2;
                                                    _loc_90 = _projectileArr[_loc_5].oldX - (_loc_89.x + _plantes[_1725].x);
                                                    _loc_91 = _projectileArr[_loc_5].oldY - (_loc_89.y + _plantes[_1725].y);
                                                    _loc_92 = Math.sqrt(_loc_90 * _loc_90 + _loc_91 * _loc_91);
                                                    if (_loc_84 == 0 || _loc_85 > _loc_92)
                                                    {
                                                        _projectileArr[_loc_5].lastIntSectionPlanet = _1725;
                                                        _projectileArr[_loc_5].lastIntSectionShape = _loc_6;
                                                        _projectileArr[_loc_5].lastIntSectionElement = _loc_10;
                                                        if (_projectileArr[_loc_5].lastRefX != _loc_89.x || _projectileArr[_loc_5].lastRefY != _loc_89.y)
                                                        {
                                                            _loc_84++;
                                                            _projectileArr[_loc_5].lastRefX = _loc_89.x;
                                                            _projectileArr[_loc_5].lastRefY = _loc_89.y;
                                                            _loc_85 = _loc_92;
                                                            _loc_27 = _loc_89.x + _plantes[_1725].x;
                                                            _loc_28 = _loc_89.y + _plantes[_1725].y;
                                                            _loc_83.push(new Point(_loc_27, _loc_28));
                                                            _loc_79 = Math.atan2(_plantes[_1725].shapeArray[_loc_6][_loc_10].y - _plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].y, _plantes[_1725].shapeArray[_loc_6][_loc_10].x - _plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].x);
                                                            _loc_51 = new Point(_projectileArr[_loc_5].momX, _projectileArr[_loc_5].momY);
                                                            _loc_52 = new Point(_loc_48.x + _plantes[_1725].x, _loc_48.y + _plantes[_1725].y);
                                                            _loc_53 = new Point(_loc_49.x + _plantes[_1725].x, _loc_49.y + _plantes[_1725].y);
                                                            _loc_54 = new Point(_loc_47.x + _plantes[_1725].x, _loc_47.y + _plantes[_1725].y);
                                                            _loc_55 = new Point(_loc_80.x + _plantes[_1725].x, _loc_80.y + _plantes[_1725].y);
                                                            _loc_56 = _1792(_loc_52, _loc_53, _loc_54, _loc_55, _loc_51, 0.5);
                                                            _loc_93 = Math.sqrt(_loc_56[1].x * _loc_56[1].x + _loc_56[1].y * _loc_56[1].y);
                                                        }// end if
                                                    }// end if
                                                }// end if
                                                _loc_10++;
                                            }// end while
                                            _loc_6++;
                                        }// end while
                                        if (_loc_84 > 0 && _loc_93 > 5)
                                        {
                                            _loc_94 = _loc_56[0].x - _projectileArr[_loc_5].oldX;
                                            _loc_95 = _loc_56[0].y - _projectileArr[_loc_5].oldY;
                                            _loc_96 = Math.sqrt(_loc_94 * _loc_94 + _loc_95 * _loc_95);
                                            _loc_98 = _loc_56[0].x - _loc_94 / _loc_96;
                                            _loc_99 = _loc_56[0].y - _loc_95 / _loc_96;
                                            _projectileArr[_loc_5].x = _loc_98;
                                            _projectileArr[_loc_5].y = _loc_99;
                                            _projectileArr[_loc_5].momX = _loc_56[1].x * 1;
                                            _projectileArr[_loc_5].momY = _loc_56[1].y * 1;
                                        }
                                        else if (_loc_84 > 0)
                                        {
                                            _projectileArr[_loc_5].removeMe = true;
                                            _mines.push(new Mine());
                                            _1764.addChild(_mines[_mines.length-1]);
                                            _mines[_mines.length-1].timeTilPrimed = _projectileArr[_loc_5].timeTilPrimed;
                                            _mines[_mines.length-1].timeTilBoom = _projectileArr[_loc_5].timeTilBoom;
                                            _mines[_mines.length-1].activated = _projectileArr[_loc_5].activated;
                                            _mines[_mines.length-1].gotoAndStop(2);
                                            _mines[_mines.length-1].positionPlanet = _projectileArr[_loc_5].lastIntSectionPlanet;
                                            _mines[_mines.length-1].positionShape = _projectileArr[_loc_5].lastIntSectionShape;
                                            _mines[_mines.length-1].positionElement = _projectileArr[_loc_5].lastIntSectionElement;
                                            _mines[_mines.length-1].positionElementX = _plantes[_projectileArr[_loc_5].lastIntSectionPlanet].shapeArray[_projectileArr[_loc_5].lastIntSectionShape][_projectileArr[_loc_5].lastIntSectionElement].x;
                                            _mines[_mines.length-1].positionElementY = _plantes[_projectileArr[_loc_5].lastIntSectionPlanet].shapeArray[_projectileArr[_loc_5].lastIntSectionShape][_projectileArr[_loc_5].lastIntSectionElement].y;
                                            _mines[_mines.length-1].x = _loc_27;
                                            _mines[_mines.length-1].y = _loc_28;
                                            _mines[_mines.length-1].rotation = _loc_79 * (180 / Math.PI);
                                        }// end else if
                                    }
                                    else
                                    {
                                        _loc_100 = _projectileArr[_loc_5].x - _plantes[_1725].x;
                                        _loc_101 = _projectileArr[_loc_5].y - _plantes[_1725].y;
                                        _loc_102 = Math.atan2(_loc_101, _loc_100);
                                        _loc_103 = Math.sqrt(_loc_100 * _loc_100 + _loc_101 * _loc_101);
                                        _loc_104 = _plantes[_1725].diameter / 2;
                                        _loc_105 = _loc_104 / _loc_103;
                                        _17b7(_plantes[_1725].x + _loc_100 * _loc_105, _plantes[_1725].y + _loc_101 * _loc_105, 1, "burn");
                                        _17ce[_17ce.length-1].rotation = _loc_102 * (180 / Math.PI);
                                        _projectileArr[_loc_5].removeMe = true;
                                    }// end else if
                                }
                                else if (_projectileArr[_loc_5] is UnitProjectile)
                                {
                                    _projectileArr[_loc_5].removeMe = true;
                                    if (!_plantes[_1725].isSun)
                                    {
                                        _17c5(0, 0, _projectileArr[_loc_5].team, false);
                                        _17a2[_17a2.length-1].team = _projectileArr[_loc_5].team;
                                        _17a2[_17a2.length-1].timeSince = _projectileArr[_loc_5].timeSince;
                                        _17a2[_17a2.length-1].damageTaken = _projectileArr[_loc_5].damageTaken;
                                        _17a2[_17a2.length-1].poisoned = _projectileArr[_loc_5].poisoned;
                                        if (_17a2[_17a2.length-1].poisoned)
                                        {
                                            _17a2[_17a2.length-1].poison.gotoAndPlay(2);
                                        }// end if
                                        _17a2[_17a2.length-1].health = _projectileArr[_loc_5].health;
                                        _17a2[_17a2.length-1].killReg = _projectileArr[_loc_5].killReg;
                                        _17a2[_17a2.length-1].maxHealth = _projectileArr[_loc_5].maxHealth;
                                        _17a2[_17a2.length-1].accuracy = _projectileArr[_loc_5].accuracy;
                                        _17a2[_17a2.length-1].unitName = _projectileArr[_loc_5].unitName;
                                        _loc_47 = new Point(_projectileArr[_loc_5].oldX - _plantes[_1725].x, _projectileArr[_loc_5].oldY - _plantes[_1725].y);
                                        _loc_80 = new Point(_loc_46.x - _loc_47.x + _loc_46.x, _loc_46.y - _loc_47.y + _loc_46.y);
                                        _loc_83 = new Array();
                                        _loc_84 = 0;
                                        _loc_85 = 5000;
                                        _loc_6 = 0;
                                        while (_loc_6 < _plantes[_1725].shapeArray.length)
                                        {
                                            // label
                                            _loc_10 = 0;
                                            while (_loc_10 < _plantes[_1725].shapeArray[_loc_6].length)
                                            {
                                                // label
                                                _loc_48 = new Point(_plantes[_1725].shapeArray[_loc_6][_loc_10].x, _plantes[_1725].shapeArray[_loc_6][_loc_10].y);
                                                _loc_49 = new Point(_plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].x, _plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].y);
                                                _loc_89 = _plantes[_1725].lineIntersectLine(_loc_47, _loc_80, _loc_48, _loc_49, true);
                                                if (_loc_89)
                                                {
                                                    _loc_90 = _projectileArr[_loc_5].oldX - (_loc_89.x + _plantes[_1725].x);
                                                    _loc_91 = _projectileArr[_loc_5].oldY - (_loc_89.y + _plantes[_1725].y);
                                                    _loc_92 = Math.sqrt(_loc_90 * _loc_90 + _loc_91 * _loc_91);
                                                    if (_loc_84 == 0 || _loc_85 > _loc_92)
                                                    {
                                                        _loc_84++;
                                                        _loc_85 = _loc_92;
                                                        _17a2[_17a2.length-1].positionPlanet = _1725;
                                                        _17a2[_17a2.length-1].positionShape = _loc_6;
                                                        _17a2[_17a2.length-1].positionElement = _loc_10;
                                                        _17a2[_17a2.length-1].positionElementX = _plantes[_1725].shapeArray[_loc_6][_loc_10].x;
                                                        _17a2[_17a2.length-1].positionElementY = _plantes[_1725].shapeArray[_loc_6][_loc_10].y;
                                                        _loc_27 = _loc_89.x + _plantes[_1725].x;
                                                        _loc_28 = _loc_89.y + _plantes[_1725].y;
                                                        _loc_83.push(new Point(_loc_27, _loc_28));
                                                        _loc_79 = Math.atan2(_plantes[_1725].shapeArray[_loc_6][_loc_10].y - _plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].y, _plantes[_1725].shapeArray[_loc_6][_loc_10].x - _plantes[_1725].shapeArray[_loc_6][(_loc_10 + 1) % _plantes[_1725].shapeArray[_loc_6].length].x);
                                                    }// end if
                                                }// end if
                                                _loc_10++;
                                            }// end while
                                            _loc_6++;
                                        }// end while
                                        _17a2[_17a2.length-1].x = _loc_27;
                                        _17a2[_17a2.length-1].y = _loc_28;
                                        _17a2[_17a2.length-1].rotation = _loc_79 * (180 / Math.PI);
                                        if (_17a2[_17a2.length-1].health - _17a2[_17a2.length-1].damageTaken > 0)
                                        {
                                            _17a2[_17a2.length-1].changeAnim("stand");
                                        }
                                        else
                                        {
                                            _17a2[_17a2.length-1].changeAnim("lay");
                                        }// end else if
                                        _17a2[_17a2.length-1].healthDisplay.x = _17a2[_17a2.length-1].x;
                                        _17a2[_17a2.length-1].healthDisplay.y = _17a2[_17a2.length-1].y;
                                        _17a2[_17a2.length-1].healthDisplay.rotation = _17a2[_17a2.length-1].rotation;
                                        _17a2[_17a2.length-1].healthDisplay.updateDisplay(_17a2[_17a2.length-1].health, _17a2[_17a2.length-1].team);
                                        _17a2[_17a2.length-1].healthDisplay.showHealth();
                                        _1734.addChild(_17a2[_17a2.length-1].healthDisplay);
                                    }
                                    else
                                    {
                                        _loc_100 = _projectileArr[_loc_5].x - _plantes[_1725].x;
                                        _loc_101 = _projectileArr[_loc_5].y - _plantes[_1725].y;
                                        _loc_102 = Math.atan2(_loc_101, _loc_100);
                                        _loc_103 = Math.sqrt(_loc_100 * _loc_100 + _loc_101 * _loc_101);
                                        _loc_104 = _plantes[_1725].diameter / 2;
                                        _loc_105 = _loc_104 / _loc_103;
                                        _17b7(_plantes[_1725].x + _loc_100 * _loc_105, _plantes[_1725].y + _loc_101 * _loc_105, 1, "burn");
                                        _17ce[_17ce.length-1].rotation = _loc_102 * (180 / Math.PI);
                                        if (myTeamsTurn)
                                        {
                                            if (_projectileArr[_loc_5].team != 0)
                                            {
                                                if (_projectileArr[_loc_5].killReg > 0)
                                                {
                                                    var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                                    var _loc_116:* = "wep" + _projectileArr[_loc_5].killReg + "Kills";
                                                    _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["wep" + _projectileArr[_loc_5].killReg + "Kills"]++;
                                                }// end if
                                                var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                                var _loc_116:String;
                                                _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["enemiesSun"]++;
                                                var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                                var _loc_116:String;
                                                _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["enemyKills"]++;
                                            }// end if
                                        }// end if
                                        if (_projectileArr[_loc_5].team == 0)
                                        {
                                            var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                            var _loc_116:String;
                                            _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["friendlyKills"]++;
                                        }// end if
                                    }// end else if
                                }
                                else if (!(_projectileArr[_loc_5] is Wep5Projectile && _projectileArr[_loc_5].inPlanet < 2))
                                {
                                    if (_projectileArr[_loc_5] is Wep2Projectile)
                                    {
                                        shake = 3;
                                        expSize = 40;
                                        if (_projectileArr[_loc_5] is Wep2Projectile)
                                        {
                                            _loc_68 = Math.atan2(_projectileArr[_loc_5].y - _projectileArr[_loc_5].oldY, _projectileArr[_loc_5].x - _projectileArr[_loc_5].oldX);
                                            _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.35), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.2), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.2), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.2), 0, "payload", _1725);
                                            _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.35), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.35), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.35), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.35), 0, "payload", _1725);
                                            _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.5), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.5), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.5), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.5), 0, "payload", _1725);
                                            _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.65), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.65), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.65), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.65), 0, "payload", _1725);
                                            _17910(_projectileArr[_loc_5].x + 10 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.65), _projectileArr[_loc_5].y + 10 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.8), 7 * Math.sin(Math.PI - _loc_68 + Math.PI * 0.8), 7 * Math.cos(Math.PI - _loc_68 + Math.PI * 0.8), 0, "payload", _1725);
                                        }// end if
                                    }
                                    else if (_projectileArr[_loc_5] is Wep7Projectile)
                                    {
                                        _174a = 0;
                                        while (_174a < _17a2.length)
                                        {
                                            // label
                                            if (_17a2[_174a].positionPlanet == _1725)
                                            {
                                                _17a2[_174a].poisoned = true;
                                                _17a2[_174a].poison.gotoAndPlay(2);
                                            }// end if
                                            _174a++;
                                        }// end while
                                    }// end else if
                                    _17ca(_projectileArr[_loc_5].x, _projectileArr[_loc_5].y, _loc_5, _1725, "proj");
                                }// end else if
                            }
                            else if (!_loc_57 && _projectileArr[_loc_5] is Wep5Projectile && _projectileArr[_loc_5].inPlanet == 1 && _projectileArr[_loc_5].planetHit == _1725)
                            {
                                _projectileArr[_loc_5].inPlanet = 2;
                                _17ca(_projectileArr[_loc_5].x, _projectileArr[_loc_5].y, _loc_5, _1725, "proj");
                            }// end else if
                            _1725++;
                        }// end while
                    }// end if
                    _loc_5++;
                }// end while
                _loc_7 = 0;
                while (_loc_7 < _projectileArr.length)
                {
                    // label
                    if (_projectileArr[_loc_7] is MineProjectile)
                    {
                        if (_projectileArr[_loc_7].intDelay > 0)
                        {
                            var _loc_115:* = _projectileArr[_loc_7];
                            _loc_115.intDelay = _projectileArr[_loc_7].intDelay--;
                        }// end if
                    }// end if
                    _loc_7++;
                }// end while
                _loc_8 = 0;
                while (_loc_8 < _mines.length)
                {
                    // label
                    if (_mines[_loc_8].timeTilPrimed > 0)
                    {
                        _mines[_loc_8].gotoAndStop(1);
                        var _loc_115:* = _mines[_loc_8];
                        _loc_115.timeTilPrimed = _mines[_loc_8].timeTilPrimed--;
                        if (_mines[_loc_8].timeTilPrimed == 0)
                        {
                            _mines[_loc_8].gotoAndStop(2);
                        }// end if
                    }
                    else if (_mines[_loc_8].activated && _mines[_loc_8].timeTilBoom > 0)
                    {
                        _mines[_loc_8].gotoAndStop(4);
                        var _loc_115:* = _mines[_loc_8];
                        _loc_115.timeTilBoom = _mines[_loc_8].timeTilBoom--;
                        if (_mines[_loc_8].timeTilBoom == 59 || _mines[_loc_8].timeTilBoom == 45 || _mines[_loc_8].timeTilBoom == 30 || _mines[_loc_8].timeTilBoom == 15 || _mines[_loc_8].timeTilBoom == 10 || _mines[_loc_8].timeTilBoom == 8 || _mines[_loc_8].timeTilBoom == 6 || _mines[_loc_8].timeTilBoom == 4 || _mines[_loc_8].timeTilBoom == 2)
                        {
                            _mines[_loc_8].gotoAndStop(5);
                            if (MovieClip(root).sfx)
                            {
                                MovieClip(root).soundmanager.sound_minebeep.gotoAndPlay(2);
                            }// end if
                        }// end if
                    }
                    else if (_mines[_loc_8].activated && _mines[_loc_8].timeTilBoom <= 0)
                    {
                        _17ca(_mines[_loc_8].x, _mines[_loc_8].y, _loc_8, -1, "mine");
                    }
                    else
                    {
                        _174a = 0;
                        while (_174a < _17a2.length)
                        {
                            // label
                            _loc_106 = _mines[_loc_8].x - _17a2[_174a].x;
                            _loc_107 = _mines[_loc_8].y - _17a2[_174a].y;
                            _loc_108 = Math.round(_loc_106 * _loc_106 + _loc_107 * _loc_107);
                            if (_loc_108 < 2500)
                            {
                                _mines[_loc_8].activated = true;
                            }// end if
                            _174a++;
                        }// end while
                    }// end else if
                    _loc_8++;
                }// end while
                _loc_9 = 0;
                while (_loc_9 < _projectileArr.length)
                {
                    // label
                    if (_projectileArr[_loc_9] is MineProjectile)
                    {
                        if (_projectileArr[_loc_9].timeTilPrimed > 0)
                        {
                            _projectileArr[_loc_9].gotoAndStop(1);
                            var _loc_115:* = _projectileArr[_loc_9];
                            _loc_115.timeTilPrimed = _projectileArr[_loc_9].timeTilPrimed--;
                            if (_projectileArr[_loc_9].timeTilPrimed == 0)
                            {
                                _projectileArr[_loc_9].gotoAndStop(2);
                            }// end if
                        }
                        else if (_projectileArr[_loc_9].activated && _projectileArr[_loc_9].timeTilBoom > 0)
                        {
                            _projectileArr[_loc_9].gotoAndStop(4);
                            var _loc_115:* = _projectileArr[_loc_9];
                            _loc_115.timeTilBoom = _projectileArr[_loc_9].timeTilBoom--;
                            if (_projectileArr[_loc_9].timeTilBoom == 59 || _projectileArr[_loc_9].timeTilBoom == 45 || _projectileArr[_loc_9].timeTilBoom == 30 || _projectileArr[_loc_9].timeTilBoom == 15 || _projectileArr[_loc_9].timeTilBoom == 10 || _projectileArr[_loc_9].timeTilBoom == 8 || _projectileArr[_loc_9].timeTilBoom == 6 || _projectileArr[_loc_9].timeTilBoom == 4 || _projectileArr[_loc_9].timeTilBoom == 2)
                            {
                                _projectileArr[_loc_9].gotoAndStop(5);
                                if (MovieClip(root).sfx)
                                {
                                    MovieClip(root).soundmanager.sound_minebeep.gotoAndPlay(2);
                                }// end if
                            }// end if
                        }
                        else if (_projectileArr[_loc_9].activated && _projectileArr[_loc_9].timeTilBoom <= 0)
                        {
                            _17ca(_projectileArr[_loc_9].x, _projectileArr[_loc_9].y, -1, -1, "dead");
                            _projectileArr[_loc_9].removeMe = true;
                        }
                        else
                        {
                            _174a = 0;
                            while (_174a < _17a2.length)
                            {
                                // label
                                _loc_106 = _projectileArr[_loc_9].x - _17a2[_174a].x;
                                _loc_107 = _projectileArr[_loc_9].y - _17a2[_174a].y;
                                _loc_108 = Math.round(_loc_106 * _loc_106 + _loc_107 * _loc_107);
                                if (_loc_108 < 2500)
                                {
                                    _projectileArr[_loc_9].activated = true;
                                }// end if
                                _174a++;
                            }// end while
                        }// end else if
                    }// end else if
                    _loc_9++;
                }// end while
                if (_178e > 0)
                {
                    _178e--;
                    _177a();
                }// end if
                while (_loc_5-- >= 0)
                {
                    // label
                    if (_projectileArr[_projectileArr.length-1].removeMe)
                    {
                        _17b8(_projectileArr[_loc_5]);
                    }// end if
                }// end while
                while (_loc_8-- >= 0)
                {
                    // label
                    if (_mines[_mines.length-1].removeMe)
                    {
                        _1755(_mines[_loc_8]);
                    }// end if
                }// end while
                while (_loc_10-- >= 0)
                {
                    // label
                    if (_17a6[_17a6.length-1].removeMe)
                    {
                        _173b(_17a6[_loc_10]);
                    }// end if
                }// end while
                while (_loc_6-- >= 0)
                {
                    // label
                    if (_1737[_1737.length-1].life <= 0)
                    {
                        if (_1737[_loc_6].timeTilDie == 0)
                        {
                            _1782(_1737[_loc_6]);
                            continue;
                        }// end if
                        var _loc_115:* = _1737[_loc_6];
                        _loc_115.timeTilDie = _1737[_loc_6].timeTilDie--;
                    }// end if
                }// end while
                while (_loc_4-- >= 0)
                {
                    // label
                    if (_177d[_177d.length-1].life <= 0)
                    {
                        _1757(_177d[_loc_4]);
                    }// end if
                }// end while
                _1776();
                _174a = _17a2.length-1;
                while (_174a >= 0)
                {
                    // label
                    if (_174a == _17be && _17210 == "shoot" && _17a2[_174a].animState.substr(0, 9) != "notaiming" && _17a2[_174a].animState.substr(0, 9) != "thinking" && _17a2[_174a].animState.substr(0, 6) != "aiming" && !_17a2[_174a].isWalking)
                    {
                        _17a2[_174a].changeAnim("notaiming" + _176c);
                    }
                    else if (!_17a2[_174a].isWalking || gameTimer.timeLeft <= 0 && _17a2[_174a].animState == "walk")
                    {
                        _17a2[_174a].changeAnim("bob");
                        _17a2[_174a].isWalking = false;
                    }
                    else if (_17a2[_174a].animState == "collapse" || _17a2[_174a].animState == "falldown" && _17a2[_174a].graphic && _17a2[_174a].graphic.currentFrame == _17a2[_174a].graphic.totalFrames)
                    {
                        _17a2[_174a].changeAnim("lay");
                    }
                    else if (_17a2[_174a].animState == "teleportout" && _17a2[_174a].graphic && _17a2[_174a].graphic.currentFrame == _17a2[_174a].graphic.totalFrames)
                    {
                        _17a2[_174a].healthDisplay.hideHealth();
                        _17a2[_174a].positionPlanet = _17a2[_174a].positionPlanetTeleTo;
                        _17a2[_174a].positionShape = _17a2[_174a].positionShapeTeleTo;
                        _17a2[_174a].positionElement = _17a2[_174a].positionElementTeleTo;
                        _17a2[_174a].positionElementX = _17a2[_174a].positionElementXTeleTo;
                        _17a2[_174a].positionElementY = _17a2[_174a].positionElementYTeleTo;
                        _17410(_17be, true);
                        _17a2[_174a].changeAnim("teleportin");
                        if (MovieClip(root).sfx)
                        {
                            MovieClip(root).soundmanager.sound_teleport.gotoAndPlay(2);
                        }// end if
                    }
                    else if (_17a2[_174a].animState != "bob" && _17a2[_174a].graphic && _17a2[_174a].graphic.currentFrame == _17a2[_174a].graphic.totalFrames)
                    {
                        _17a2[_174a].changeAnim("bob");
                    }
                    else if (_17a2[_174a].animState == "bob" && _17a2[_174a].graphic && _17a2[_174a].graphic.currentFrame == _17a2[_174a].graphic.totalFrames)
                    {
                        if (Math.random() < 0.3)
                        {
                            _loc_109 = Math.floor(Math.random() * 7);
                            if (_loc_109 == 0)
                            {
                                _17a2[_174a].changeAnim("turnhead");
                            }
                            else if (_loc_109 == 1)
                            {
                                _17a2[_174a].changeAnim("wave");
                            }
                            else if (_loc_109 == 2 && MovieClip(root).achievementsInfo.aCount >= 20)
                            {
                                _17a2[_174a].changeAnim("yoyo");
                            }
                            else if (_loc_109 == 3 && MovieClip(root).achievementsInfo.aCount >= 4)
                            {
                                _17a2[_174a].changeAnim("blowgum");
                            }
                            else if (_loc_109 == 4 && MovieClip(root).achievementsInfo.aCount >= 36)
                            {
                                _17a2[_174a].changeAnim("mp3");
                            }
                            else if (_loc_109 == 5 && MovieClip(root).achievementsInfo.aCount >= 12)
                            {
                                _17a2[_174a].changeAnim("phone");
                            }
                            else if (_loc_109 == 6 && MovieClip(root).achievementsInfo.aCount >= 28)
                            {
                                _17a2[_174a].changeAnim("juggle");
                            }
                            else
                            {
                                _17a2[_174a].changeAnim("bob");
                            }// end else if
                        }// end else if
                    }// end else if
                    _174a--;
                }// end while
                if (shake > 0)
                {
                    _1753();
                    shake = shake - 0.5;
                }// end if
                if (_17210 == "shoot" && gameTimer.timeLeft <= 0 && _17ce.length == 0 && _projectileArr.length == 0 && _177d.length == 0)
                {
                    _loc_110 = 0;
                    _loc_8 = 0;
                    while (_loc_8 < _mines.length)
                    {
                        // label
                        if (_mines[_loc_8].activated)
                        {
                            _loc_110++;
                        }// end if
                        _loc_8++;
                    }// end while
                    if (_loc_110 == 0)
                    {
                        _173d();
                    }// end if
                }// end if
                if (_17210 == "sim" && _projectileArr.length == 0 && _17ce.length == 0 && _177d.length == 0 && gameTimer.timeLeft <= 0)
                {
                    _loc_110 = 0;
                    _loc_8 = 0;
                    while (_loc_8 < _mines.length)
                    {
                        // label
                        if (_mines[_loc_8].activated)
                        {
                            _loc_110++;
                        }// end if
                        _loc_8++;
                    }// end while
                    if (_loc_110 == 0)
                    {
                        _17210 = "damage";
                        _1735.showMe();
                        if (!myTeamsTurn)
                        {
                            _179a();
                        }// end if
                        _174a = 0;
                        while (_174a < _17a2.length)
                        {
                            // label
                            if (_17a2[_174a].poisoned)
                            {
                                _17a2[_174a].damageTaken = _17a2[_174a].damageTaken + 5;
                            }// end if
                            _174a++;
                        }// end while
                    }// end if
                }// end if
                if (_17210 == "damage" && _projectileArr.length == 0 && _17ce.length == 0 && _177d.length == 0)
                {
                    _174a = 0;
                    while (_174a < _17a2.length)
                    {
                        // label
                        _17a2[_174a].healthShown = _17a2[_174a].health;
                        _17a2[_174a].health = _17a2[_174a].health - _17a2[_174a].damageTaken;
                        if (_17a2[_174a].damageTaken > 0)
                        {
                            _1784.push(new HealthFloat());
                            _1734.addChild(_1784[_1784.length-1]);
                            _1784[_1784.length-1].updateDisplay(_17a2[_174a].damageTaken, _17a2[_174a].team, false);
                            _1784[_1784.length-1].x = _17a2[_174a].x;
                            _1784[_1784.length-1].y = _17a2[_174a].y;
                            _1784[_1784.length-1].rotation = _17a2[_174a].rotation;
                        }// end if
                        if (_17a2[_174a].health <= 0)
                        {
                            _17a2[_174a].changeAnim("collapse");
                            _17a2[_174a].health = 0;
                        }// end if
                        _17a2[_174a].damageTaken = 0;
                        _17a2[_174a].healthDisplay.num.text = _17a2[_174a].healthShown.toString();
                        _174a++;
                    }// end while
                    _17210 = "react";
                }// end if
                if (_17210 == "react" && _projectileArr.length == 0)
                {
                    _loc_111 = true;
                    _loc_112 = 0;
                    while (_loc_112 < _17a2.length)
                    {
                        // label
                        if (_17a2[_loc_112].health != _17a2[_loc_112].healthShown)
                        {
                            if (_17a2[_loc_112].healthShown - _17a2[_loc_112].health > 50)
                            {
                                _17a2[_loc_112].healthShown = _17a2[_loc_112].healthShown - 5;
                            }
                            else if (_17a2[_loc_112].healthShown - _17a2[_loc_112].health > 20)
                            {
                                _17a2[_loc_112].healthShown = _17a2[_loc_112].healthShown - 2;
                            }
                            else
                            {
                                _17a2[_loc_112].healthShown--;
                            }// end else if
                            _17a2[_loc_112].healthDisplay.num.text = _17a2[_loc_112].healthShown.toString();
                            _loc_111 = false;
                        }
                        else if (_17a2[_loc_112].healthShown == 0)
                        {
                            _loc_111 = false;
                            if (_17a2[_loc_112].animState == "lay" && _projectileArr.length == 0 && _17ce.length == 0)
                            {
                                _17ca(_17a2[_loc_112].x, _17a2[_loc_112].y, _loc_112, -1, "dead");
                                if (_17a2[_loc_112].team == 0)
                                {
                                    var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                    var _loc_116:String;
                                    _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["friendlyKills"]++;
                                }// end if
                                _17a2[_loc_112].removeMe = true;
                                if (myTeamsTurn && _17a2[_loc_112].team != 0)
                                {
                                    var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                    var _loc_116:String;
                                    _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["enemyKills"]++;
                                    if (_17a2[_loc_112].killReg > 0)
                                    {
                                        var _loc_115:* = MovieClip(root).achievementsInfo.stats;
                                        var _loc_116:* = "wep" + _17a2[_loc_112].killReg + "Kills";
                                        _loc_115[_loc_116] = MovieClip(root).achievementsInfo.stats["wep" + _17a2[_loc_112].killReg + "Kills"]++;
                                    }// end if
                                }// end if
                            }// end if
                        }
                        else if (_17a2[_loc_112].animState == "lay")
                        {
                            _17a2[_loc_112].changeAnim("stand");
                        }// end else if
                        _loc_112++;
                    }// end while
                    if (_loc_111)
                    {
                        _1776();
                        _173d();
                    }// end if
                }// end if
                if (_17210 == "gameover" && MovieClip(root).msg.messageQueue.length == 0 && MovieClip(root).msg.currentFrame == 1)
                {
                    _loc_113 = 1;
                    if (_176f <= MovieClip(root).levelSetup.criteria[0])
                    {
                        _loc_113 = 3;
                    }
                    else if (_176f <= MovieClip(root).levelSetup.criteria[1])
                    {
                        _loc_113 = 2;
                    }// end else if
                    MovieClip(root).lastGameTurns = _176f;
                    MovieClip(root).lastGameMedal = _loc_113;
                    doQuit();
                }// end if
                _cam.doMove();
                x = Math.round(_cam.posX);
                y = Math.round(_cam.posY);
                _172b.fillRect(_17c7, 0);
                while (_loc_11-- >= 0)
                {
                    // label
                    _175d[_175d.length-1].moveMe();
                    _172b.copyPixels(_17b6[_175d[_loc_11].type], new Rectangle(20 * _175d[_loc_11].life--, 0, 20, 20), new Point(_175d[_loc_11].posX + x - 10, _175d[_loc_11].posY + y - 10), null, null, true);
                    if (_175d[_loc_11].life > _175d[_loc_11].maxLife)
                    {
                        _175d.splice(_loc_11, 1);
                    }// end if
                }// end while
                if (_178d > -1)
                {
                    _178d--;
                    if (_178d == -1)
                    {
                        _1778.graphics.clear();
                    }// end if
                }// end if
                if (_17210 == "gameover")
                {
                    _174a = 0;
                    while (_174a < _17a2.length)
                    {
                        // label
                        if (_17a2[_174a].animState == "worm" && _17a2[_174a].graphic && _17a2[_174a].graphic.currentFrame >= 18 && _17a2[_174a].graphic.currentFrame <= 26)
                        {
                            if (_17a2[_174a].scaleX == -1)
                            {
                                _17c4(_174a, 1);
                            }
                            else
                            {
                                _17cb(_174a, 1);
                            }// end else if
                        }
                        else if (_17a2[_174a].animState == "moonwalk" || _17a2[_174a].animState == "hands" && _17a2[_174a].graphic && _17a2[_174a].graphic.currentFrame >= 27)
                        {
                            if (_17a2[_174a].scaleX == -1)
                            {
                                _17c4(_174a, 1);
                            }
                            else
                            {
                                _17cb(_174a, 1);
                            }// end else if
                        }// end else if
                        _174a++;
                    }// end while
                }// end if
                _1735.mainLoop();
                _1749 = 0;
                while (_1749 < _17b10)
                {
                    // label
                    _loc_114 = Math.round(teamHealths[_1749] / _172d * 100);
                    _17a1[_1749].mainLoop();
                    _1749++;
                }// end while
                _loc_12 = MovieClip(root).starmaptransclose.scrollRect;
                _loc_12.x = -x / 4 + MovieClip(root).starmaptransclose.width / 2;
                _loc_12.y = -y / 4 + MovieClip(root).starmaptransclose.height / 2;
                MovieClip(root).starmaptransclose.scrollRect = _loc_12;
                _loc_12 = MovieClip(root).starmaptransmid.scrollRect;
                _loc_12.x = -x / 8 + MovieClip(root).starmaptransmid.width / 2;
                _loc_12.y = -y / 8 + MovieClip(root).starmaptransmid.height / 2;
                MovieClip(root).starmaptransmid.scrollRect = _loc_12;
                _1766.x = -x;
                _1766.y = -y;
                _1775.x = -x;
                _1775.y = -y;
                _loc_13 = false;
                _loc_14 = 0;
                while (_loc_14 < _projectileArr.length)
                {
                    // label
                    if (_projectileArr[_loc_14].hitTestObject(gameTimer))
                    {
                        _loc_13 = true;
                    }// end if
                    _loc_14++;
                }// end while
                _17a1[_17a5].doFlash();
                if (_loc_13 && gameTimer.timeLeft > 0)
                {
                    gameTimer.alpha = 0.25;
                }
                else if (gameTimer.alpha > 0)
                {
                    gameTimer.alpha = 1;
                }// end else if
                if (MovieClip(root).msg)
                {
                    MovieClip(root).msg.mainLoop();
                }// end if
            }// end if
            return;
        }// end function

        public function _173d()
        {
            var _loc_1:int;
            var _loc_2:int;
            var _loc_3:*;
            var _loc_4:Array;
            if (stage.hasEventListener(MouseEvent.MOUSE_UP))
            {
                stage.addEventListener(MouseEvent.MOUSE_DOWN, _17b1);
                stage.removeEventListener(MouseEvent.MOUSE_UP, _1747);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, _177a);
                _1785.graphics.clear();
            }// end if
            _17c6.gotoAndStop(34);
            _17210 = "shoot";
            _176c = 1;
            _wepIcon.gotoAndStop(1);
            _loc_1 = 0;
            while (_loc_1 < _17b10)
            {
                // label
                if (_17a1[_loc_1])
                {
                    _17a1[_loc_1].resetAlpha();
                }// end if
                _loc_1++;
            }// end while
            if (_17a2[_17be])
            {
                _17a2[_17be].changeAnim("bob");
            }// end if
            _174a = 0;
            while (_174a < _17a2.length)
            {
                // label
                var _loc_5:* = _17a2[_174a];
                _loc_5.timeSince = _17a2[_174a].timeSince++;
                _17a2[_174a].healthDisplay.x = _17a2[_174a].x;
                _17a2[_174a].healthDisplay.y = _17a2[_174a].y;
                _17a2[_174a].healthDisplay.rotation = _17a2[_174a].rotation;
                _17a2[_174a].healthDisplay.showHealth();
                _174a++;
            }// end while
            _loc_2 = 0;
            while (_loc_2 < _17a6.length)
            {
                // label
                var _loc_5:* = _17a6[_loc_2];
                _loc_5.timeSince = _17a6[_loc_2].timeSince++;
                if (_17a6[_loc_2].timeSince >= 8)
                {
                    _17a6[_loc_2].gotoAndPlay(30);
                    _17a6[_loc_2].expired = true;
                }// end if
                _loc_2++;
            }// end while
            myTeamsTurn = !myTeamsTurn;
            _177b(false);
            if (_17210 != "gameover")
            {
                if (myTeamsTurn)
                {
                    _176f++;
                    _17ab.alpha = 1;
                    _17a5 = 0;
                    _17c3();
                    _179a();
                    _17be = _1745(0);
                    _17a2[_17be].timeSince = 0;
                    _1774();
                }
                else
                {
                    _17ab.alpha = 0;
                    _17be = _1745(_1779[0]);
                    _17a2[_17be].timeSince = 0;
                    _17a5 = _1779[0];
                    _17b4();
                    _loc_4 = _1779.splice(0, 1);
                    _1779.push(_loc_4[0]);
                    _1733();
                }// end else if
                gameTimer.resetTimer();
                gameTimer.changeCol(_17a2[_17be].team);
                _loc_3 = Math.random();
                if (_loc_3 < 0.125 && _17a6.length < 10)
                {
                    _1751("health");
                }
                else if (_loc_3 < 0.25 && _17a6.length < 10 && MovieClip(root).achievementsInfo.levelsUnlocked >= 3)
                {
                    _1751("weapon");
                }// end else if
                MovieClip(root).msg.addMessage(_17a2[_17be].unitName + "\'s Turn", _17a2[_17be].team);
                _cam.setTarget(_17a2[_17be], _175b, _177c, _1795, _1797);
            }// end if
            return;
        }// end function

        public function _173e(e:MouseEvent)
        {
            if (_17610[7] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(10);
                _17c1();
            }// end if
            return;
        }// end function

        public function _17310(param1, param2, param3, param4, param5)
        {
            var _loc_6:Boolean;
            var _loc_7:int;
            var _loc_8:Array;
            var _loc_9:Boolean;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:Point;
            var _loc_13:Point;
            var _loc_14:int;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:Number;
            var _loc_18:Point;
            var _loc_19:Point;
            var _loc_20:int;
            var _loc_21:int;
            var _loc_22:int;
            _loc_6 = true;
            _loc_7 = 0;
            _loc_8 = new Array();
            while (_loc_7 < _17a2.length && _loc_6 || param5 == "snipe")
            {
                // label
                if (_17a2[_loc_7].team != _17a2[param1].team)
                {
                    _loc_9 = false;
                    if (param2 == null)
                    {
                        _loc_15 = _17a2[param1].x + 16 * Math.sin((180 - _17a2[param1].rotation) * (Math.PI / 180));
                        _loc_16 = _17a2[param1].y + 16 * Math.cos((180 - _17a2[param1].rotation) * (Math.PI / 180));
                    }
                    else
                    {
                        _loc_17 = Math.atan2(_plantes[param2].shapeArray[param3][param4].y - _plantes[param2].shapeArray[param3][(param4 + 1) % _plantes[param2].shapeArray[param3].length].y, _plantes[param2].shapeArray[param3][param4].x - _plantes[param2].shapeArray[param3][(param4 + 1) % _plantes[param2].shapeArray[param3].length].x);
                        if (param5 == "change")
                        {
                            _loc_15 = _plantes[param2].x + _plantes[param2].shapeArray[param3][param4].x + 16 * Math.sin(Math.PI - _loc_17);
                            _loc_16 = _plantes[param2].y + _plantes[param2].shapeArray[param3][param4].y + 16 * Math.cos(Math.PI - _loc_17);
                        }
                        else if (param5 == "retreat")
                        {
                            _loc_15 = _plantes[param2].x + _plantes[param2].shapeArray[param3][param4].x + 30 * Math.sin(Math.PI - _loc_17);
                            _loc_16 = _plantes[param2].y + _plantes[param2].shapeArray[param3][param4].y + 30 * Math.cos(Math.PI - _loc_17);
                        }// end else if
                    }// end else if
                    _loc_10 = _17a2[_loc_7].x + 16 * Math.sin((180 - _17a2[_loc_7].rotation) * (Math.PI / 180));
                    _loc_11 = _17a2[_loc_7].y + 16 * Math.cos((180 - _17a2[_loc_7].rotation) * (Math.PI / 180));
                    _loc_12 = new Point(_loc_15, _loc_16);
                    _loc_13 = new Point(_loc_10, _loc_11);
                    _loc_14 = 0;
                    while (_loc_14 < _1737.length)
                    {
                        // label
                        if (_1737[_loc_14 + 1])
                        {
                            _loc_18 = new Point(_1737[_loc_14].x, _1737[_loc_14].y);
                            _loc_19 = new Point(_1737[_loc_14 + 1].x, _1737[_loc_14 + 1].y);
                            if (lineIntersectLine(_loc_12, _loc_13, _loc_18, _loc_19, true))
                            {
                                _loc_9 = true;
                            }// end if
                        }// end if
                        _loc_14 = _loc_14 + 2;
                    }// end while
                    if (true)
                    {
                        _loc_20 = 0;
                        while (_loc_20 < _plantes.length)
                        {
                            // label
                            _loc_21 = 0;
                            while (_loc_21 < _plantes[_loc_20].shapeArray.length)
                            {
                                // label
                                _loc_22 = 0;
                                while (_loc_22 < _plantes[_loc_20].shapeArray[_loc_21].length)
                                {
                                    // label
                                    _loc_18 = new Point(_plantes[_loc_20].shapeArray[_loc_21][_loc_22].x + _plantes[_loc_20].x, _plantes[_loc_20].shapeArray[_loc_21][_loc_22].y + _plantes[_loc_20].y);
                                    _loc_19 = new Point(_plantes[_loc_20].shapeArray[_loc_21][(_loc_22 + 1) % _plantes[_loc_20].shapeArray[_loc_21].length].x + _plantes[_loc_20].x, _plantes[_loc_20].shapeArray[_loc_21][(_loc_22 + 1) % _plantes[_loc_20].shapeArray[_loc_21].length].y + _plantes[_loc_20].y);
                                    if (lineIntersectLine(_loc_12, _loc_13, _loc_18, _loc_19, true))
                                    {
                                        _loc_9 = true;
                                    }// end if
                                    _loc_22++;
                                }// end while
                                _loc_21++;
                            }// end while
                            _loc_20++;
                        }// end while
                    }// end if
                    if (_loc_9 == false)
                    {
                        _loc_8.push(_loc_7);
                        _loc_6 = false;
                    }// end if
                }// end if
                _loc_7++;
            }// end while
            if (param5 == "snipe" && !_loc_6)
            {
                return _loc_8;
            }// end if
            return _loc_6;
        }// end function

        public function _1744(param1:KeyboardEvent)
        {
            var _loc_2:int;
            while (_loc_2-- >= 0)
            {
                // label
                if (_1763[_1763.length-1] == param1.keyCode)
                {
                    _1763.splice(_loc_2, 1);
                }// end if
            }// end while
            return;
        }// end function

        public function _1745(param1)
        {
            var _loc_2:int;
            var _loc_3:int;
            _loc_2 = -100;
            _loc_3 = 0;
            _174a = 0;
            while (_174a < _17a2.length)
            {
                // label
                if (_17a2[_174a].team == param1 && !_17a2[_174a].removeMe && _17a2[_174a].timeSince > _loc_2)
                {
                    _loc_2 = _17a2[_174a].timeSince;
                    _loc_3 = _174a;
                }// end if
                _174a++;
            }// end while
            return _loc_3;
        }// end function

        public function _1747(param1:MouseEvent)
        {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            var _loc_12:*;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_16:*;
            var _loc_17:*;
            var _loc_18:*;
            var _loc_19:*;
            var _loc_20:*;
            var _loc_21:*;
            var _loc_22:*;
            var _loc_23:*;
            var _loc_24:*;
            var _loc_25:*;
            var _loc_26:*;
            var _loc_27:*;
            var _loc_28:*;
            var _loc_29:*;
            var _loc_30:*;
            var _loc_31:*;
            var _loc_32:Boolean;
            var _loc_33:*;
            var _loc_34:*;
            var _loc_35:*;
            var _loc_36:int;
            var _loc_37:*;
            var _loc_38:*;
            var _loc_39:*;
            var _loc_40:int;
            var _loc_41:int;
            var _loc_42:*;
            var _loc_43:*;
            var _loc_44:*;
            _17a2[_17be].changeAnim("bob");
            _loc_2 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
            _loc_3 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
            if (_176c == 9)
            {
                _loc_5 = _1737[_1737.length-1].x - mouseX;
                _loc_6 = _1737[_1737.length-1].y - mouseY;
            }
            else if (_176c == 3)
            {
                _loc_5 = _1767.x - mouseX;
                _loc_6 = _1767.y - mouseY;
            }
            else
            {
                _loc_5 = _loc_2 - mouseX;
                _loc_6 = _loc_3 - mouseY;
            }// end else if
            _loc_4 = Math.sqrt(_loc_5 * _loc_5 + _loc_6 * _loc_6);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, _17b1);
            stage.removeEventListener(MouseEvent.MOUSE_UP, _1747);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, _177a);
            aiming = false;
            if (_loc_4 > 20)
            {
                if (_176c == 1 || _176c == 2)
                {
                    if (MovieClip(root).sfx)
                    {
                        MovieClip(root).soundmanager.sound_rocketshoot.gotoAndPlay(2);
                    }// end if
                }// end if
                if (_176c != 10)
                {
                    _1735.hideMe();
                    _17b4();
                }// end if
                if (_176c == 4)
                {
                    _loc_7 = (mouseX - _loc_2) / 10;
                    _loc_8 = (mouseY - _loc_3) / 10;
                    _loc_9 = Math.sqrt(_loc_7 * _loc_7 + _loc_8 * _loc_8);
                    _loc_10 = 10 / _loc_9;
                    _loc_7 = _loc_7 * _loc_10;
                    _loc_8 = _loc_8 * _loc_10;
                    _loc_2 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                    _loc_3 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                }
                else if (_176c != 8 && _176c != 9 && _176c != 10)
                {
                    _loc_7 = (mouseX - _17af.x) / 10;
                    _loc_8 = (mouseY - _17af.y) / 10;
                }// end else if
                if (_176c == 4)
                {
                    _17910(_17af.x, _17af.y, _loc_7, _loc_8, 0, "bullet", null);
                    _1778.graphics.lineStyle(1, 16777215, 1);
                    _178d = 2;
                    if (MovieClip(root).sfx)
                    {
                        MovieClip(root).soundmanager.sound_sniper.gotoAndPlay(2);
                    }// end if
                    do
                    {
                        // label
                        _1778.graphics.moveTo(_projectileArr[_projectileArr.length-1].x, _projectileArr[_projectileArr.length-1].y);
                        _projectileArr[_projectileArr.length-1].doGravity(_plantes);
                        _projectileArr[_projectileArr.length-1].moveProjectile(_175b, _1795, _177c, _1797);
                        _1778.graphics.lineTo(_projectileArr[_projectileArr.length-1].x, _projectileArr[_projectileArr.length-1].y);
                        _loc_11 = 0;
                        while (_loc_11 < _1737.length)
                        {
                            // label
                            if (_1737[_loc_11 + 1])
                            {
                                _loc_13 = new Point(_1737[_loc_11].x, _1737[_loc_11].y);
                                _loc_14 = new Point(_1737[_loc_11 + 1].x, _1737[_loc_11 + 1].y);
                                _loc_15 = new Point(_projectileArr[_projectileArr.length-1].x, _projectileArr[_projectileArr.length-1].y);
                                _loc_16 = new Point(_projectileArr[_projectileArr.length-1].oldX, _projectileArr[_projectileArr.length-1].oldY);
                                _loc_17 = lineIntersectLine(_loc_13, _loc_14, _loc_15, _loc_16, true);
                                if (!_projectileArr[_projectileArr.length-1].removeMe && _loc_17 && _projectileArr[_projectileArr.length-1].shieldDelay <= 0)
                                {
                                    _loc_18 = _loc_17.x;
                                    _loc_19 = _loc_17.y;
                                    _loc_20 = new Point(_projectileArr[_projectileArr.length-1].momX, _projectileArr[_projectileArr.length-1].momY);
                                    _loc_21 = new Point(_loc_13.x, _loc_13.y);
                                    _loc_22 = new Point(_loc_14.x, _loc_14.y);
                                    _loc_23 = new Point(_loc_15.x, _loc_15.y);
                                    _loc_24 = new Point(_loc_16.x, _loc_16.y);
                                    _loc_25 = _1792(_loc_21, _loc_22, _loc_23, _loc_24, _loc_20, 1);
                                    _projectileArr[_projectileArr.length-1].reflected = true;
                                    _projectileArr[_projectileArr.length-1].shieldDelay = 2;
                                    _projectileArr[_projectileArr.length-1].x = _loc_18;
                                    _projectileArr[_projectileArr.length-1].y = _loc_19;
                                    _projectileArr[_projectileArr.length-1].momX = _loc_25[1].x;
                                    _projectileArr[_projectileArr.length-1].momY = _loc_25[1].y;
                                }// end if
                            }// end if
                            _loc_11 = _loc_11 + 2;
                        }// end while
                        _loc_12 = _1773(_projectileArr[_projectileArr.length-1]);
                        if (_loc_12)
                        {
                            _projectileArr[_projectileArr.length-1].removeMe = true;
                            if (_loc_12[0] == "unit")
                            {
                                _17a2[_loc_12[1]].changeAnim("falldown");
                                if (_17a2[_loc_12[1]].killReg == -1 && _17a2[_loc_12[1]].health <= _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi)
                                {
                                    _17a2[_loc_12[1]].killReg = 4;
                                }// end if
                                _17a2[_loc_12[1]].damageTaken = _17a2[_loc_12[1]].damageTaken + _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi;
                                if (_17a2[_loc_12[1]].team != 0 && myTeamsTurn)
                                {
                                    _1794 = _1794 + _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi;
                                }// end if
                            }// end if
                        }// end if
                    }while (!_projectileArr[_projectileArr.length-1].removeMe)
                    var _loc_45:* = _17610;
                    var _loc_46:int;
                    _loc_45[_loc_46] = _17610[2]--;
                }
                else if (_176c == 8)
                {
                    _mines.push(new Mine());
                    _1764.addChild(_mines[_mines.length-1]);
                    _mines[_mines.length-1].x = _17a2[_17be].x;
                    _mines[_mines.length-1].y = _17a2[_17be].y;
                    _mines[_mines.length-1].positionPlanet = _17a2[_17be].positionPlanet;
                    _mines[_mines.length-1].positionShape = _17a2[_17be].positionShape;
                    _mines[_mines.length-1].positionElement = _17a2[_17be].positionElement;
                    _mines[_mines.length-1].positionElementX = _17a2[_17be].positionElementX;
                    _mines[_mines.length-1].positionElementY = _17a2[_17be].positionElementY;
                    _mines[_mines.length-1].rotation = _17a2[_17be].rotation;
                    var _loc_45:* = _17610;
                    var _loc_46:int;
                    _loc_45[_loc_46] = _17610[4]--;
                }
                else if (_176c == 9)
                {
                    _loc_26 = _173f.x - _1737[_1737.length-1].x;
                    _loc_27 = _173f.y - _1737[_1737.length-1].y;
                    _loc_28 = Math.sqrt(_loc_26 * _loc_26 + _loc_27 * _loc_27);
                    _1778.removeChild(_173f);
                    _1737.push(new ShieldNode());
                    _1778.addChild(_1737[_1737.length-1]);
                    _1737[_1737.length-1].x = _173f.x;
                    _1737[_1737.length-1].y = _173f.y;
                    _loc_29 = _1737[_1737.length - 2].x - _1737[_1737.length-1].x;
                    _loc_30 = _1737[_1737.length - 2].y - _1737[_1737.length-1].y;
                    _loc_31 = Math.atan2(_loc_30, _loc_29) - Math.PI / 2;
                    _1737[_1737.length-1].shieldLine = new ShieldLine();
                    _1737[_1737.length-1].shieldLine.scaleY = _loc_28 / 100;
                    _1737[_1737.length-1].shieldLine.rotation = _loc_31 * (180 / Math.PI);
                    _175c.addChild(_1737[_1737.length-1].shieldLine);
                    _1737[_1737.length-1].shieldLine.x = _173f.x;
                    _1737[_1737.length-1].shieldLine.y = _173f.y;
                    var _loc_45:* = _17610;
                    var _loc_46:int;
                    _loc_45[_loc_46] = _17610[5]--;
                }
                else if (_176c == 10)
                {
                    _loc_32 = false;
                    _loc_33 = 400;
                    _loc_34 = -1;
                    _loc_35 = -1;
                    _loc_36 = 0;
                    while (_loc_36 < _plantes.length)
                    {
                        // label
                        _loc_37 = _plantes[_loc_36].x - mouseX;
                        _loc_38 = _plantes[_loc_36].y - mouseY;
                        _loc_39 = Math.sqrt(_loc_37 * _loc_37 + _loc_38 * _loc_38);
                        if (!_plantes[_loc_36].isSun && _loc_39 < _plantes[_loc_36].diameter / 2 + 20)
                        {
                            _loc_33 = 400;
                            _loc_34 = -1;
                            _loc_35 = -1;
                            _loc_40 = 0;
                            while (_loc_40 < _plantes[_loc_36].shapeArray.length)
                            {
                                // label
                                _loc_41 = 0;
                                while (_loc_41 < _plantes[_loc_36].shapeArray[_loc_40].length)
                                {
                                    // label
                                    _loc_42 = _plantes[_loc_36].shapeArray[_loc_40][_loc_41].x + _plantes[_loc_36].x - mouseX;
                                    _loc_43 = _plantes[_loc_36].shapeArray[_loc_40][_loc_41].y + _plantes[_loc_36].y - mouseY;
                                    _loc_44 = _loc_42 * _loc_42 + _loc_43 * _loc_43;
                                    if (_loc_44 < _loc_33)
                                    {
                                        _loc_33 = _loc_44;
                                        _loc_34 = _loc_40;
                                        _loc_35 = _loc_41;
                                    }// end if
                                    _loc_41++;
                                }// end while
                                _loc_40++;
                            }// end while
                            if (_loc_33 < 400)
                            {
                                _1735.hideMe();
                                _17b4();
                                _17a2[_17be].healthDisplay.hideHealth();
                                _17a2[_17be].positionPlanetTeleTo = _loc_36;
                                _17a2[_17be].positionShapeTeleTo = _loc_34;
                                _17a2[_17be].positionElementTeleTo = _loc_35;
                                _17a2[_17be].positionElementXTeleTo = _plantes[_loc_36].shapeArray[_loc_34][_loc_35].x;
                                _17a2[_17be].positionElementYTeleTo = _plantes[_loc_36].shapeArray[_loc_34][_loc_35].y;
                                _17a2[_17be].changeAnim("teleportout");
                                if (MovieClip(root).sfx)
                                {
                                    MovieClip(root).soundmanager.sound_teleport.gotoAndPlay(2);
                                }// end if
                                _loc_32 = true;
                                var _loc_45:* = _17610;
                                var _loc_46:int;
                                _loc_45[_loc_46] = _17610[7]--;
                            }// end if
                        }// end if
                        _loc_36++;
                    }// end while
                }
                else
                {
                    if (_176c == 2)
                    {
                        var _loc_45:* = _17610;
                        var _loc_46:int;
                        _loc_45[_loc_46] = _17610[1]--;
                    }
                    else if (_176c == 6)
                    {
                        var _loc_45:* = _17610;
                        var _loc_46:int;
                        _loc_45[_loc_46] = _17610[3]--;
                    }
                    else if (_176c == 5)
                    {
                        var _loc_45:* = _17610;
                        var _loc_46:int;
                        _loc_45[_loc_46] = _17610[6]--;
                    }
                    else if (_176c == 7)
                    {
                        var _loc_45:* = _17610;
                        var _loc_46:int;
                        _loc_45[_loc_46] = _17610[8]--;
                    }
                    else if (_176c == 3)
                    {
                        var _loc_45:* = _17610;
                        var _loc_46:int;
                        _loc_45[_loc_46] = _17610[9]--;
                    }// end else if
                    _17910(_17af.x, _17af.y, _loc_7, _loc_8, 0, "bullet", null);
                }// end else if
                if (_176c != 10 || _loc_32)
                {
                    gameTimer.hideIt();
                    gameTimer.resetRetreatTimer();
                    _17210 = "sim";
                    _17bc();
                }// end if
            }
            else if (_176c == 9)
            {
                _1778.removeChild(_173f);
                _1778.removeChild(_1737[_1737.length-1]);
                _1737.splice(_1737.length-1, 1);
            }// end else if
            _17ba();
            return;
        }// end function

        public function _174d(param1, param2)
        {
            var _loc_3:*;
            _loc_3 = PixelPerfectCollisionDetection.isColliding(param1, param2, this, true, 0);
            if (_loc_3)
            {
                return _loc_3;
            }// end if
            return false;
        }// end function

        public function _17410(param1, param2)
        {
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_9:Number;
            _loc_3 = _17a2[param1].positionPlanet;
            _loc_4 = _17a2[param1].positionShape;
            _loc_5 = _17a2[param1].positionElement;
            _loc_6 = _17a2[param1].positionPlace;
            _loc_7 = Math.atan2(_plantes[_loc_3].shapeArray[_loc_4][_loc_5].y - _plantes[_loc_3].shapeArray[_loc_4][(_loc_5 + 1) % _plantes[_loc_3].shapeArray[_loc_4].length].y, _plantes[_loc_3].shapeArray[_loc_4][_loc_5].x - _plantes[_loc_3].shapeArray[_loc_4][(_loc_5 + 1) % _plantes[_loc_3].shapeArray[_loc_4].length].x);
            _loc_8 = _loc_6 * Math.sin(3 * Math.PI / 2 - _loc_7);
            _loc_9 = _loc_6 * Math.cos(3 * Math.PI / 2 - _loc_7);
            _17a2[param1].x = _plantes[_loc_3].shapeArray[_loc_4][_loc_5].x + _plantes[_loc_3].x + _loc_8;
            _17a2[param1].y = _plantes[_loc_3].shapeArray[_loc_4][_loc_5].y + _plantes[_loc_3].y + _loc_9;
            if (param2)
            {
                _17a2[param1].rotation = _loc_7 * (180 / Math.PI);
            }// end if
            return;
        }// end function

        public function _1751(param1)
        {
            var _loc_2:int;
            var _loc_3:*;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            var _loc_12:*;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_16:Number;
            if (param1 == "health")
            {
                _17a6.push(new PickupHealth());
            }
            else if (param1 == "weapon")
            {
                _17a6.push(new PickupWeapon());
            }// end else if
            _173c.addChild(_17a6[_17a6.length-1]);
            _loc_2 = 0;
            do
            {
                // label
                _loc_3 = Math.floor(Math.random() * _plantes.length);
                _loc_4 = Math.floor(Math.random() * _plantes[_loc_3].shapeArray.length);
                _loc_5 = Math.floor(Math.random() * _plantes[_loc_3].shapeArray[_loc_4].length);
                _17a6[_17a6.length-1].positionPlanet = _loc_3;
                _17a6[_17a6.length-1].positionShape = _loc_4;
                _17a6[_17a6.length-1].positionElement = _loc_5;
                _17a6[_17a6.length-1].positionElementX = _plantes[_loc_3].shapeArray[_loc_4][_loc_5].x;
                _17a6[_17a6.length-1].positionElementY = _plantes[_loc_3].shapeArray[_loc_4][_loc_5].y;
                _17a6[_17a6.length-1].x = _plantes[_loc_3].shapeArray[_loc_4][_loc_5].x + _plantes[_loc_3].x;
                _17a6[_17a6.length-1].y = _plantes[_loc_3].shapeArray[_loc_4][_loc_5].y + _plantes[_loc_3].y;
                _loc_6 = false;
                _loc_7 = 0;
                while (_loc_7++ < _17a2.length)
                {
                    // label
                    _loc_10 = _17a6[_17a6.length-1].x - _17a2[_loc_7].x;
                    _loc_11 = _17a6[_17a6.length-1].y - _17a2[_loc_7].y;
                    _loc_12 = _loc_10 * _loc_10 + _loc_11 * _loc_11;
                    if (_loc_12 < 3600)
                    {
                        _loc_6 = true;
                    }// end if
                }// end while
                _loc_8 = 0;
                while (_loc_8++ < _17a6.length-1)
                {
                    // label
                    _loc_13 = _17a6[_17a6.length-1].x - _17a6[_loc_8].x;
                    _loc_14 = _17a6[_17a6.length-1].y - _17a6[_loc_8].y;
                    _loc_15 = _loc_13 * _loc_13 + _loc_14 * _loc_14;
                    if (_loc_15 < 2500)
                    {
                        _loc_6 = true;
                    }// end if
                }// end while
                _loc_9 = true;
                if (_loc_6 || _plantes[_loc_3].isSun)
                {
                    _loc_9 = false;
                }// end if
                _loc_2++;
            }while (!_loc_9 || _loc_2 > 30)
            if (_loc_2 > 30)
            {
                _173c.removeChild(_17a6[_17a6.length-1]);
                _17a6.splice(_17a6.length-1, 1);
            }
            else
            {
                _cam.setTarget(_17a6[_17a6.length-1], _175b, _177c, _1795, _1797);
                _loc_16 = Math.atan2(_plantes[_loc_3].shapeArray[_loc_4][_loc_5].y - _plantes[_loc_3].shapeArray[_loc_4][(_loc_5 + 1) % _plantes[_loc_3].shapeArray[_loc_4].length].y, _plantes[_loc_3].shapeArray[_loc_4][_loc_5].x - _plantes[_loc_3].shapeArray[_loc_4][(_loc_5 + 1) % _plantes[_loc_3].shapeArray[_loc_4].length].x);
                _17a6[_17a6.length-1].rotation = _loc_16 * (180 / Math.PI);
            }// end else if
            return;
        }// end function

        public function _1752(param1)
        {
            var _loc_2:Boolean;
            var _loc_3:int;
            _loc_2 = false;
            _loc_3 = 0;
            while (_loc_3 < _plantes.length)
            {
                // label
                if (_plantes[_loc_3].shape2.hitTestPoint(param1.x + x, param1.y + y))
                {
                    _loc_2 = true;
                }// end if
                _loc_3++;
            }// end while
            return _loc_2;
        }// end function

        public function _1753()
        {
            x = Math.round(Math.random() * shake - shake / 2);
            y = Math.round(Math.random() * shake - shake / 2);
            MovieClip(root).bgimage.x = x;
            MovieClip(root).bgimage.y = y;
            return;
        }// end function

        public function _1754(param1, param2)
        {
            var _loc_3:*;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:int;
            var _loc_12:int;
            var _loc_13:int;
            var _loc_14:Number;
            var _loc_15:*;
            var _loc_16:*;
            var _loc_17:*;
            var _loc_18:Number;
            var _loc_19:Number;
            var _loc_20:*;
            var _loc_21:*;
            _mines.push(new Mine());
            _1764.addChild(_mines[_mines.length-1]);
            if (param2 < 0)
            {
                param2 = param2 + 360;
            }// end if
            if (param2 > 360)
            {
                param2 = param2 - 360;
            }// end if
            _mines[_mines.length-1].positionPlanet = param1;
            _mines[_mines.length-1].positionShape = 0;
            _loc_3 = _plantes[param1].x;
            _loc_4 = _plantes[param1].y;
            _loc_5 = _plantes[param1].x - 200 * Math.sin((90 - param2) * (Math.PI / 180));
            _loc_6 = _plantes[param1].y - 200 * Math.cos((90 - param2) * (Math.PI / 180));
            _loc_7 = new Point(_loc_3 - _plantes[param1].x, _loc_4 - _plantes[param1].y);
            _loc_8 = new Point(_loc_5 - _plantes[param1].x, _loc_6 - _plantes[param1].y);
            _loc_9 = 0;
            while (_loc_9 < _plantes[param1].shapeArray[0].length)
            {
                // label
                _loc_20 = new Point(_plantes[param1].shapeArray[0][_loc_9].x, _plantes[param1].shapeArray[0][_loc_9].y);
                _loc_21 = new Point(_plantes[param1].shapeArray[0][(_loc_9 + 1) % _plantes[param1].shapeArray[0].length].x, _plantes[param1].shapeArray[0][(_loc_9 + 1) % _plantes[param1].shapeArray[0].length].y);
                if (_plantes[_1725].lineIntersectLine(_loc_7, _loc_8, _loc_20, _loc_21, true))
                {
                    _mines[_mines.length-1].positionElement = _loc_9;
                    _mines[_mines.length-1].positionElementX = _plantes[_mines[_mines.length-1].positionPlanet].shapeArray[_mines[_mines.length-1].positionShape][_loc_9].x;
                    _mines[_mines.length-1].positionElementY = _plantes[_mines[_mines.length-1].positionPlanet].shapeArray[_mines[_mines.length-1].positionShape][_loc_9].y;
                }// end if
                _loc_9++;
            }// end while
            _loc_10 = _mines[_mines.length-1].positionPlanet;
            _loc_11 = _mines[_mines.length-1].positionShape;
            _loc_12 = _mines[_mines.length-1].positionElement;
            _loc_13 = _mines[_mines.length-1].positionPlace;
            _loc_14 = Math.atan2(_plantes[_loc_10].shapeArray[_loc_11][_loc_12].y - _plantes[_loc_10].shapeArray[_loc_11][(_loc_12 + 1) % _plantes[_loc_10].shapeArray[_loc_11].length].y, _plantes[_loc_10].shapeArray[_loc_11][_loc_12].x - _plantes[_loc_10].shapeArray[_loc_11][(_loc_12 + 1) % _plantes[_loc_10].shapeArray[_loc_11].length].x);
            _loc_15 = _plantes[_loc_10].diameter / 2;
            _loc_16 = _plantes[_loc_10].shapeArray[_loc_11][_loc_12].x / _loc_15;
            _loc_17 = _plantes[_loc_10].shapeArray[_loc_11][_loc_12].y / _loc_15;
            _loc_18 = _loc_16;
            _loc_19 = _loc_17;
            _mines[_mines.length-1].x = _plantes[_loc_10].shapeArray[_loc_11][_loc_12].x + _plantes[_loc_10].x + _loc_18;
            _mines[_mines.length-1].y = _plantes[_loc_10].shapeArray[_loc_11][_loc_12].y + _plantes[_loc_10].y + _loc_19;
            _mines[_mines.length-1].rotation = _loc_14 * (180 / Math.PI);
            return;
        }// end function

        public function _1755(param1)
        {
            var _loc_2:int;
            _loc_2 = _mines.indexOf(param1);
            _1764.removeChild(param1);
            _mines.splice(_loc_2, 1);
            return;
        }// end function

        public function _1756()
        {
            var _loc_1:int;
            _17ad.graphics.clear();
            _loc_1 = 0;
            while (_loc_1 < _1737.length)
            {
                // label
                _17ad.graphics.lineStyle(2, 39423, 1);
                _17ad.graphics.moveTo(_1737[_loc_1].x, _1737[_loc_1].y);
                _17ad.graphics.lineTo(_1737[_loc_1 + 1].x, _1737[_loc_1 + 1].y);
                _loc_1 = _loc_1 + 2;
            }// end while
            return;
        }// end function

        public function _1757(param1)
        {
            var _loc_2:int;
            _loc_2 = _177d.indexOf(param1);
            _1778.removeChild(param1);
            _177d.splice(_loc_2, 1);
            return;
        }// end function

        public function _1758(param1, param2, param3, param4, param5, param6, param7)
        {
            var _loc_8:*;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            var _loc_12:*;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_16:*;
            var _loc_17:*;
            var _loc_18:*;
            _loc_8 = Math.pow(param3 - param1, 2) + Math.pow(param4 - param2, 2);
            _loc_9 = 2 * ((param3 - param1) * (param1 - param5) + (param4 - param2) * (param2 - param6));
            _loc_10 = Math.pow(param5, 2) + Math.pow(param6, 2) + Math.pow(param1, 2) + Math.pow(param2, 2) - 2 * (param5 * param1 + param6 * param2) - Math.pow(param7, 2);
            _loc_11 = _loc_9 * _loc_9 - 4 * _loc_8 * _loc_10;
            _loc_12 = 0;
            _loc_13 = 0;
            _loc_14 = 0;
            _loc_15 = 0;
            _loc_16 = 0;
            _loc_17 = 0;
            if (_loc_11 > 0)
            {
                _loc_16 = (-_loc_9 - Math.sqrt(_loc_11)) / (2 * _loc_8);
                _loc_17 = (-_loc_9 + Math.sqrt(_loc_11)) / (2 * _loc_8);
                _loc_12 = param1 + _loc_16 * (param3 - param1);
                _loc_13 = param2 + _loc_16 * (param4 - param2);
                _loc_14 = param1 + _loc_17 * (param3 - param1);
                _loc_15 = param2 + _loc_17 * (param4 - param2);
                _loc_18 = [_loc_12, _loc_13, _loc_14, _loc_15];
                return _loc_18;
            }// end if
            return false;
        }// end function

        public function showMulti(param1, param2, param3)
        {
            if (param1 == 2)
            {
                _17ce.push(new MultiDisplayX2());
            }
            else if (param1 == 3)
            {
                _17ce.push(new MultiDisplayX3());
            }
            else if (param1 == 4)
            {
                _17ce.push(new MultiDisplayX4());
            }// end else if
            _17ce[_17ce.length-1].x = param2;
            _17ce[_17ce.length-1].y = param3;
            _17a9.addChild(_17ce[_17ce.length-1]);
            return;
        }// end function

        public function lineIntersectLine(param1:Point, param2:Point, param3:Point, param4:Point, param5:Boolean = true) : Point
        {
            var _loc_6:Point;
            var _loc_7:Number;
            var _loc_8:Number;
            var _loc_9:Number;
            var _loc_10:Number;
            var _loc_11:Number;
            var _loc_12:Number;
            var _loc_13:Number;
            _loc_7 = param2.y - param1.y;
            _loc_9 = param1.x - param2.x;
            _loc_11 = param2.x * param1.y - param1.x * param2.y;
            _loc_8 = param4.y - param3.y;
            _loc_10 = param3.x - param4.x;
            _loc_12 = param4.x * param3.y - param3.x * param4.y;
            _loc_13 = _loc_7 * _loc_10 - _loc_8 * _loc_9;
            if (_loc_13 == 0)
            {
                return null;
            }// end if
            _loc_6 = new Point();
            _loc_6.x = (_loc_9 * _loc_12 - _loc_10 * _loc_11) / _loc_13;
            _loc_6.y = (_loc_8 * _loc_11 - _loc_7 * _loc_12) / _loc_13;
            if (param5)
            {
                if (Math.pow(_loc_6.x - param2.x, 2) + Math.pow(_loc_6.y - param2.y, 2) > Math.pow(param1.x - param2.x, 2) + Math.pow(param1.y - param2.y, 2))
                {
                    return null;
                }// end if
                if (Math.pow(_loc_6.x - param1.x, 2) + Math.pow(_loc_6.y - param1.y, 2) > Math.pow(param1.x - param2.x, 2) + Math.pow(param1.y - param2.y, 2))
                {
                    return null;
                }// end if
                if (Math.pow(_loc_6.x - param4.x, 2) + Math.pow(_loc_6.y - param4.y, 2) > Math.pow(param3.x - param4.x, 2) + Math.pow(param3.y - param4.y, 2))
                {
                    return null;
                }// end if
                if (Math.pow(_loc_6.x - param3.x, 2) + Math.pow(_loc_6.y - param3.y, 2) > Math.pow(param3.x - param4.x, 2) + Math.pow(param3.y - param4.y, 2))
                {
                    return null;
                }// end if
            }// end if
            return _loc_6;
        }// end function

        public function removeHealthFloat(param1)
        {
            var _loc_2:int;
            _loc_2 = _1784.indexOf(param1);
            _1734.removeChild(_1784[_loc_2]);
            _1784.splice(_loc_2, 1);
            return;
        }// end function

        public function _1761(param1:MouseEvent)
        {
            _1771(1);
            _17c1();
            return;
        }// end function

        public function _1762(param1:MouseEvent)
        {
            if (_17610[9] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(3);
                _17c1();
            }// end if
            return;
        }// end function

        public function _1765(param1:MouseEvent)
        {
            if (_17610[1] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(2);
                _17c1();
            }// end if
            return;
        }// end function

        public function _1769(param1:MouseEvent)
        {
            if (_17610[8] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(7);
                _17c1();
            }// end if
            return;
        }// end function

        public function _176b(param1:MouseEvent)
        {
            if (_17610[5] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(9);
                _17c1();
            }// end if
            return;
        }// end function

        public function _176d(param1:MouseEvent)
        {
            if (_17610[2] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(4);
                _17c1();
            }// end if
            return;
        }// end function

        public function _176e(param1:MouseEvent)
        {
            if (_17610[6] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(5);
                _17c1();
            }// end if
            return;
        }// end function

        public function _1771(param1)
        {
            _176c = param1;
            _17a2[_17be].changeAnim("notaiming" + param1);
            _wepIcon.gotoAndStop(param1);
            panelWeps.hideIt();
            return;
        }// end function

        public function _1773(param1)
        {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:Number;
            var _loc_6:int;
            _loc_6 = 0;
            while (_loc_6 < _17a2.length)
            {
                // label
                _loc_2 = param1.x - _17a2[_loc_6].x;
                _loc_3 = param1.y - _17a2[_loc_6].y;
                _loc_4 = _loc_2 * _loc_2 + _loc_3 * _loc_3;
                if (_loc_4 < 1600 && _loc_6 != _17be || param1.life > 5 && _17b2(_17a2[_loc_6], param1))
                {
                    return new Array("unit", _loc_6);
                }// end if
                _loc_6++;
            }// end while
            _1725 = 0;
            while (_1725 < _plantes.length)
            {
                // label
                _loc_2 = param1.x - _plantes[_1725].x;
                _loc_3 = param1.y - _plantes[_1725].y;
                _loc_4 = _loc_2 * _loc_2 + _loc_3 * _loc_3;
                _loc_5 = (_plantes[_1725].diameter + param1.width) / 2 * ((_plantes[_1725].diameter + param1.width) / 2);
                if (_loc_4 < _loc_5 && _17b9(_plantes[_1725], param1))
                {
                    return new Array("planet", _1725);
                }// end if
                _1725++;
            }// end while
            if (param1.x > _1795 + 1000 || param1.x < _175b - 1000 || param1.y > _1797 + 1000 || param1.y < _177c - 1000)
            {
                return new Array("bounds", 0);
            }// end if
            return false;
        }// end function

        public function _1774()
        {
            _17c6.x = _17a2[_17be].x;
            _17c6.y = _17a2[_17be].y;
            _17c6.rotation = _17a2[_17be].rotation;
            _17c6.gotoAndPlay(1);
            _17a2[_17be].changeAnim("wave");
            return;
        }// end function

        public function _1776()
        {
            _174a = _17a2.length-1;
            while (_174a >= 0)
            {
                // label
                if (_17a2[_174a].removeMe)
                {
                    if (_174a < _17be)
                    {
                        _17be--;
                    }// end if
                    _1734.removeChild(_17a2[_174a].healthDisplay);
                    _173a(_17a2[_174a]);
                }// end if
                _174a--;
            }// end while
            return;
        }// end function

        public function _1777(param1:MouseEvent)
        {
            if (_17610[3] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(6);
                _17c1();
            }// end if
            return;
        }// end function

        public function _177a(param1:MouseEvent = null)
        {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            var _loc_9:*;
            var _loc_10:int;
            var _loc_11:int;
            var _loc_12:int;
            var _loc_13:Number;
            var _loc_14:int;
            var _loc_15:Number;
            var _loc_16:Boolean;
            var _loc_17:Number;
            var _loc_18:Number;
            var _loc_19:Number;
            var _loc_20:Number;
            var _loc_21:Number;
            var _loc_22:int;
            var _loc_23:int;
            var _loc_24:int;
            var _loc_25:int;
            var _loc_26:int;
            var _loc_27:int;
            var _loc_28:int;
            var _loc_29:int;
            var _loc_30:Number;
            var _loc_31:*;
            var _loc_32:*;
            var _loc_33:Number;
            var _loc_34:Number;
            var _loc_35:*;
            var _loc_36:*;
            var _loc_37:int;
            var _loc_38:*;
            var _loc_39:*;
            var _loc_40:*;
            var _loc_41:*;
            var _loc_42:Point;
            var _loc_43:Point;
            var _loc_44:Point;
            var _loc_45:Point;
            var _loc_46:*;
            var _loc_47:*;
            var _loc_48:*;
            var _loc_49:Point;
            var _loc_50:Point;
            var _loc_51:Point;
            var _loc_52:Point;
            var _loc_53:Point;
            var _loc_54:Array;
            var _loc_55:Boolean;
            var _loc_56:int;
            var _loc_57:*;
            var _loc_58:*;
            var _loc_59:*;
            var _loc_60:*;
            var _loc_61:*;
            var _loc_62:*;
            var _loc_63:*;
            _loc_2 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
            _loc_3 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
            if (_176c == 9)
            {
                _loc_5 = _1737[_1737.length-1].x - mouseX;
                _loc_6 = _1737[_1737.length-1].y - mouseY;
            }
            else if (_176c == 3)
            {
                _loc_5 = _1767.x - mouseX;
                _loc_6 = _1767.y - mouseY;
            }
            else
            {
                _loc_5 = _loc_2 - mouseX;
                _loc_6 = _loc_3 - mouseY;
            }// end else if
            _loc_4 = Math.sqrt(_loc_5 * _loc_5 + _loc_6 * _loc_6);
            if (_loc_4 > 20)
            {
                if (_17a2[_17be].animState.substr(0, 6) != "aiming")
                {
                    _17a2[_17be].changeAnim("aiming" + _176c);
                }// end if
                if (_176c != 8 && _176c != 9 && _176c != 10)
                {
                    _loc_7 = Math.atan2(mouseY - _loc_3, mouseX - _loc_2) - Math.PI / 2;
                    _loc_8 = _17a2[_17be].rotation * (Math.PI / 180);
                    _loc_9 = (_loc_8 - _loc_7) * (180 / Math.PI);
                    if (_loc_9 < 0)
                    {
                        _loc_9 = _loc_9 + 360;
                    }// end if
                    if (_loc_9 > 360)
                    {
                        _loc_9 = _loc_9 - 360;
                    }// end if
                    if (_loc_9 < 180 && _17a2[_17be].graphic)
                    {
                        _17a2[_17be].scaleX = -1;
                        _17a2[_17be].graphic.gotoAndStop(Math.round(_loc_9));
                    }
                    else if (_17a2[_17be].graphic)
                    {
                        _17a2[_17be].scaleX = 1;
                        _17a2[_17be].graphic.gotoAndStop(Math.round(180 - (_loc_9 - 180)));
                    }// end else if
                    if (_176c == 3)
                    {
                        _17af = new Point(_1767.x, _1767.y);
                    }
                    else
                    {
                        _17af = new Point(_17a2[_17be].graphic.wep.localToGlobal(new Point(_17a2[_17be].graphic.wep.start.x, _17a2[_17be].graphic.wep.start.y)).x - x, _17a2[_17be].graphic.wep.localToGlobal(new Point(_17a2[_17be].graphic.wep.start.x, _17a2[_17be].graphic.wep.start.y)).y - y);
                    }// end else if
                    _loc_2 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                    _loc_3 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                    if (_176c == 4)
                    {
                        _loc_35 = (mouseX - _loc_2) / 10;
                        _loc_36 = (mouseY - _loc_3) / 10;
                    }
                    else
                    {
                        _loc_35 = (mouseX - _17af.x) / 10;
                        _loc_36 = (mouseY - _17af.y) / 10;
                    }// end else if
                    _loc_10 = getTimer();
                    _1741 = new TargetProjectile();
                    _1778.addChild(_1741);
                    _1741.x = _17af.x;
                    _1741.y = _17af.y;
                    if (_176c == 4)
                    {
                        _1741.mass = 0;
                    }// end if
                    _1741.momX = _loc_35;
                    _1741.momY = _loc_36;
                    _1785.graphics.clear();
                    _1785.graphics.moveTo(_1741.x, _1741.y);
                    _loc_11 = 100;
                    _loc_12 = 100 / (2 * (_17a2[_17be].accuracy + 6));
                    _loc_13 = 0;
                    _loc_14 = 6;
                    _loc_15 = 0;
                    _loc_16 = false;
                    _loc_26 = _loc_22 - _loc_24;
                    _loc_27 = _loc_23 - _loc_25;
                    _loc_28 = _loc_24 - _loc_22;
                    _loc_29 = _loc_25 - _loc_23;
                    _loc_31 = 0;
                    _loc_32 = false;
                    _loc_33 = 30 * _17a2[_17be].accuracy-- + 100;
                    _loc_34 = _loc_33;
                    while (_loc_34 > 0 && !_loc_32)
                    {
                        // label
                        _loc_22 = _1741.x;
                        _loc_23 = _1741.y;
                        _1741.doGravity(_plantes);
                        _1741.moveProjectile(_175b, _1795, _177c, _1797);
                        _loc_32 = _1773(_1741);
                        _loc_37 = 0;
                        while (_loc_37 < _1737.length)
                        {
                            // label
                            if (_1737[_loc_37 + 1])
                            {
                                _loc_42 = new Point(_1737[_loc_37].x, _1737[_loc_37].y);
                                _loc_43 = new Point(_1737[_loc_37 + 1].x, _1737[_loc_37 + 1].y);
                                _loc_44 = new Point(_1741.x, _1741.y);
                                _loc_45 = new Point(_1741.oldX, _1741.oldY);
                                _loc_46 = lineIntersectLine(_loc_42, _loc_43, _loc_44, _loc_45, true);
                                if (!_1741.removeMe && _loc_46 && _1741.shieldDelay <= 0)
                                {
                                    _loc_47 = _loc_46.x;
                                    _loc_48 = _loc_46.y;
                                    _loc_49 = new Point(_1741.momX, _1741.momY);
                                    _loc_50 = new Point(_loc_42.x, _loc_42.y);
                                    _loc_51 = new Point(_loc_43.x, _loc_43.y);
                                    _loc_52 = new Point(_loc_44.x, _loc_44.y);
                                    _loc_53 = new Point(_loc_45.x, _loc_45.y);
                                    _loc_54 = _1792(_loc_50, _loc_51, _loc_52, _loc_53, _loc_49, 1);
                                    _1741.reflected = true;
                                    _1741.shieldDelay = 2;
                                    _1741.x = _loc_47;
                                    _1741.y = _loc_48;
                                    _1741.momX = _loc_54[1].x;
                                    _1741.momY = _loc_54[1].y;
                                }// end if
                            }// end if
                            _loc_37 = _loc_37 + 2;
                        }// end while
                        _loc_11 = _loc_34 / _loc_33 * 100;
                        _loc_24 = _1741.x;
                        _loc_25 = _1741.y;
                        _loc_21 = Math.sqrt((_loc_22 - _loc_24) * (_loc_22 - _loc_24) + (_loc_23 - _loc_25) * (_loc_23 - _loc_25));
                        _loc_38 = (_loc_24 - _loc_22) / _loc_21;
                        _loc_39 = (_loc_25 - _loc_23) / _loc_21;
                        _loc_40 = _loc_13 + _loc_21;
                        _loc_34 = _loc_34 - _loc_21;
                        _loc_41 = 0;
                        if (_loc_40 > _loc_14)
                        {
                            _loc_15 = _loc_14 - _loc_13;
                            _loc_40 = _loc_40 - _loc_14;
                            if (_loc_16 == true)
                            {
                                _1785.graphics.lineStyle(3, 16750848, 0);
                            }
                            else
                            {
                                _1785.graphics.lineStyle(3, 39423, _loc_11 / 100);
                            }// end else if
                            _loc_17 = _loc_22;
                            _loc_19 = _loc_23;
                            _loc_18 = _loc_22 + _loc_38 * _loc_15;
                            _loc_20 = _loc_23 + _loc_39 * _loc_15;
                            _loc_30 = Math.sqrt((_loc_22 - _loc_24) * (_loc_22 - _loc_24) + (_loc_23 - _loc_25) * (_loc_23 - _loc_25));
                            _1785.graphics.lineTo(_loc_18, _loc_20);
                            while (_loc_40 > _loc_14)
                            {
                                // label
                                _loc_40 = _loc_40 - _loc_14;
                                if (_loc_16 == true)
                                {
                                    _loc_16 = false;
                                    _1785.graphics.lineStyle(3, 39423, _loc_11 / 100);
                                }
                                else
                                {
                                    _loc_16 = true;
                                    _1785.graphics.lineStyle(3, 16750848, 0);
                                }// end else if
                                _loc_17 = _loc_22 + _loc_38 * (_loc_15 + _loc_41 * _loc_14);
                                _loc_19 = _loc_23 + _loc_39 * (_loc_15 + _loc_41 * _loc_14);
                                _loc_18 = _loc_22 + _loc_38 * (_loc_15 + (_loc_41 + 1) * _loc_14);
                                _loc_20 = _loc_23 + _loc_39 * (_loc_15 + (_loc_41 + 1) * _loc_14);
                                _loc_30 = Math.sqrt((_loc_22 - _loc_24) * (_loc_22 - _loc_24) + (_loc_23 - _loc_25) * (_loc_23 - _loc_25));
                                _1785.graphics.lineTo(_loc_18, _loc_20);
                            }// end while
                            if (_loc_16 == true)
                            {
                                _loc_16 = false;
                                _1785.graphics.lineStyle(3, 39423, _loc_11 / 100);
                            }
                            else
                            {
                                _loc_16 = true;
                                _1785.graphics.lineStyle(3, 16750848, 0);
                            }// end else if
                            _loc_17 = _loc_22 + _loc_38 * (_loc_15 + _loc_41++ * _loc_14);
                            _loc_19 = _loc_23 + _loc_39 * (_loc_15 + _loc_41 * _loc_14);
                            _loc_18 = _loc_24;
                            _loc_20 = _loc_25;
                            _loc_30 = Math.sqrt((_loc_22 - _loc_24) * (_loc_22 - _loc_24) + (_loc_23 - _loc_25) * (_loc_23 - _loc_25));
                            _1785.graphics.lineTo(_loc_18, _loc_20);
                        }
                        else
                        {
                            if (_loc_16 == true)
                            {
                                _1785.graphics.lineStyle(3, 16750848, 0);
                            }
                            else
                            {
                                _1785.graphics.lineStyle(3, 39423, _loc_11 / 100);
                            }// end else if
                            _loc_30 = Math.sqrt((_loc_22 - _loc_24) * (_loc_22 - _loc_24) + (_loc_23 - _loc_25) * (_loc_23 - _loc_25));
                            _1785.graphics.lineTo(_loc_24, _loc_25);
                        }// end else if
                        _loc_13 = _loc_40;
                    }// end while
                    _1778.removeChild(_1741);
                }
                else if (_176c == 9)
                {
                    _1737[_1737.length-1].alpha = 1;
                    _173f.alpha = 1;
                    _loc_55 = false;
                    _loc_56 = 0;
                    while (_loc_56 < _plantes.length)
                    {
                        // label
                        _loc_60 = mouseX - _plantes[_loc_56].x;
                        _loc_61 = mouseY - _plantes[_loc_56].y;
                        _loc_62 = Math.sqrt(_loc_60 * _loc_60 + _loc_61 * _loc_61);
                        if (_loc_62 < (16 + _plantes[_loc_56].diameter) / 2)
                        {
                            _loc_55 = true;
                        }// end if
                        _loc_56++;
                    }// end while
                    if (true)
                    {
                        _173f.x = mouseX;
                        _173f.y = mouseY;
                    }// end if
                    _loc_57 = _173f.x - _1737[_1737.length-1].x;
                    _loc_58 = _173f.y - _1737[_1737.length-1].y;
                    _loc_59 = Math.sqrt(_loc_57 * _loc_57 + _loc_58 * _loc_58);
                    if (_loc_59 > 100)
                    {
                        _loc_63 = 100 / _loc_59;
                        _173f.x = _1737[_1737.length-1].x + _loc_57 * _loc_63;
                        _173f.y = _1737[_1737.length-1].y + _loc_58 * _loc_63;
                    }// end if
                    _1785.graphics.clear();
                    _1785.graphics.lineStyle(2, 39423, 1);
                    _1785.graphics.moveTo(_1737[_1737.length-1].x, _1737[_1737.length-1].y);
                    _1785.graphics.lineTo(_173f.x, _173f.y);
                }// end else if
            }
            else
            {
                _1785.graphics.clear();
                if (_17a2[_17be].animState.substr(0, 9) != "notaiming")
                {
                    _17a2[_17be].changeAnim("notaiming" + _176c);
                }// end if
                if (_176c == 9)
                {
                    _1737[_1737.length-1].alpha = 0;
                    _173f.alpha = 0;
                }// end if
            }// end else if
            return;
        }// end function

        public function _177b(param1)
        {
            var _loc_2:int;
            _177e();
            _1749 = 0;
            while (_1749 < teamHealths.length)
            {
                // label
                if (teamHealths[_1749] > _172d)
                {
                    _172d = teamHealths[_1749];
                }// end if
                _1749++;
            }// end while
            _1749 = 0;
            while (_1749 < _17b10)
            {
                // label
                _loc_2 = Math.round(teamHealths[_1749] / _172d * 100);
                if (param1)
                {
                    _17a1[_1749].bar.gotoAndStop(101 - _loc_2);
                    _17a1[_1749].setTargetFrame(101 - _loc_2);
                }
                else
                {
                    _17a1[_1749].setTargetFrame(101 - _loc_2);
                }// end else if
                _1749++;
            }// end while
            _17b3();
            return;
        }// end function

        public function _177e()
        {
            var _loc_1:Array;
            var _loc_2:int;
            _loc_1 = new Array();
            _1749 = 0;
            while (_1749 < _17b10)
            {
                // label
                _loc_1.push(teamHealths[_1749]);
                _1749++;
            }// end while
            teamHealths = new Array();
            _1749 = 0;
            while (_1749 < _17b10)
            {
                // label
                teamHealths.push(0);
                _1749++;
            }// end while
            _174a = 0;
            while (_174a < _17a2.length)
            {
                // label
                teamHealths[_17a2[_174a].team] = teamHealths[_17a2[_174a].team] + _17a2[_174a].health;
                _174a++;
            }// end while
            _1749 = 0;
            while (_1749 < _17b10)
            {
                // label
                if (_loc_1[_1749] > 0 && teamHealths[_1749] == 0)
                {
                    while (_loc_2-- >= 0)
                    {
                        // label
                        if (_1779[_1779.length-1] == _1749)
                        {
                            _1779.splice(_loc_2, 1);
                        }// end if
                    }// end while
                }// end if
                _1749++;
            }// end while
            return;
        }// end function

        public function doRestart(param1:MouseEvent = null)
        {
            var _loc_2:int;
            _17bb();
            while (_loc_2-- >= 0)
            {
                // label
                MovieClip(root).msg.messageQueue.splice(MovieClip(root).msg.messageQueue.length-1, 1);
            }// end while
            MovieClip(root).msg.gotoAndStop(1);
            MovieClip(root).restartGame();
            return;
        }// end function

        public function _1782(param1)
        {
            var _loc_2:int;
            _loc_2 = _1737.indexOf(param1);
            if (param1.shieldLine)
            {
                _175c.removeChild(param1.shieldLine);
            }// end if
            _1778.removeChild(param1);
            _1737.splice(_loc_2, 1);
            return;
        }// end function

        public function _1786(param1)
        {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:Number;
            var _loc_5:int;
            _loc_5 = 0;
            while (_loc_5 < _17a2.length)
            {
                // label
                _loc_2 = param1.x - _17a2[_loc_5].x;
                _loc_3 = param1.y - _17a2[_loc_5].y;
                _loc_4 = _loc_2 * _loc_2 + _loc_3 * _loc_3;
                if (_loc_5 != _17be || param1.life > 5 && _loc_4 < 1600)
                {
                    return new Array("unit", _loc_5);
                }// end if
                _loc_5++;
            }// end while
            _1725 = 0;
            while (_1725 < _plantes.length)
            {
                // label
                if (_plantes[_1725].shape2.hitTestPoint(param1.x + x, param1.y + y, true))
                {
                    return new Array("planet", _1725);
                }// end if
                _1725++;
            }// end while
            if (param1.x > _1795 + 1000 || param1.x < _175b - 1000 || param1.y > _1797 + 1000 || param1.y < _177c - 1000)
            {
                return new Array("bounds", 0);
            }// end if
            return false;
        }// end function

        public function removeExplosion(param1)
        {
            var _loc_2:int;
            _loc_2 = _17ce.indexOf(param1);
            _17a9.removeChild(_17ce[_loc_2]);
            _17ce.splice(_loc_2, 1);
            return;
        }// end function

        public function _178f(param1:MouseEvent)
        {
            if (_17610[4] > 0 || MovieClip(root).achievementsInfo.infAmmo)
            {
                _1771(8);
                _17c1();
            }// end if
            return;
        }// end function

        function _1792(param1, param2, param3, param4, param5, param6)
        {
            var _loc_7:Point;
            var _loc_8:Point;
            var _loc_9:Point;
            var _loc_10:Point;
            var _loc_11:*;
            var _loc_12:*;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_16:*;
            var _loc_17:Point;
            var _loc_18:Point;
            var _loc_19:Number;
            var _loc_20:Number;
            var _loc_21:Point;
            var _loc_22:Point;
            _loc_8 = new Point(0, 0);
            _loc_7 = lineIntersectLine(param1, param2, param3, param4, true);
            _17a9.graphics.clear();
            _loc_9 = new Point(_loc_7.x, _loc_7.y);
            _loc_10 = new Point(_loc_7.x - param5.x, _loc_7.y - param5.y);
            _loc_11 = Math.atan2(param1.x - param2.x, param1.y - param2.y);
            _loc_12 = _loc_11 - Math.PI / 2;
            _loc_13 = Math.atan2(_loc_9.x - _loc_10.x, _loc_9.y - _loc_10.y);
            _loc_14 = _loc_12 - _loc_13;
            _loc_15 = _loc_12 + _loc_14;
            _loc_16 = Math.sqrt(param5.x * param5.x + param5.y * param5.y);
            _loc_17 = new Point(_loc_7.x, _loc_7.y);
            _loc_18 = new Point(_loc_7.x - Math.sin(_loc_12) * 50, _loc_7.y - Math.cos(_loc_12) * 50);
            _loc_19 = Math.sin(_loc_15) * _loc_16;
            _loc_20 = Math.cos(_loc_15) * _loc_16;
            _loc_8 = new Point(-1 * param6 * _loc_19, -1 * param6 * _loc_20);
            _loc_21 = new Point(_loc_7.x, _loc_7.y);
            _loc_22 = new Point(_loc_7.x - _loc_19, _loc_7.y - Math.cos(_loc_15) * 50);
            return new Array(_loc_7, _loc_8);
        }// end function

        public function _179a()
        {
            _wepIcon.alpha = 1;
            _wepIcon.mouseEnabled = true;
            panelWeps.alpha = 1;
            panelWeps.mouseEnabled = true;
            panelWeps.mouseChildren = true;
            return;
        }// end function

        public function wepIconClicked(e:MouseEvent)
        {
            if (!panelWeps.shown)
            {
                panelWeps.showIt();
            }
            else
            {
                panelWeps.hideIt();
            }// end else if
            return;
        }// end function

        public function _17910(param1, param2, param3, param4, param5, param6, param7)
        {
            if (param6 == "bullet")
            {
                if (_176c == 1)
                {
                    _projectileArr.push(new Wep1Projectile());
                }
                else if (_176c == 2)
                {
                    _projectileArr.push(new Wep2Projectile());
                }
                else if (_176c == 3)
                {
                    _177d.push(new BlackHole());
                    if (MovieClip(root).sfx)
                    {
                        MovieClip(root).soundmanager.sound_blackhole.gotoAndPlay(2);
                    }// end if
                    _1778.addChild(_177d[_177d.length-1]);
                    _177d[_177d.length-1].rotation = Math.atan2(param4, param3) * (180 / Math.PI);
                    _177d[_177d.length-1].x = param1;
                    _177d[_177d.length-1].y = param2;
                    _177d[_177d.length-1].powerX = param3;
                    _177d[_177d.length-1].powerY = param4;
                }
                else if (_176c == 4)
                {
                    _projectileArr.push(new Wep4Projectile());
                }
                else if (_176c == 5)
                {
                    _projectileArr.push(new Wep5Projectile());
                }
                else if (_176c == 6)
                {
                    _projectileArr.push(new Wep6Projectile());
                }
                else if (_176c == 7)
                {
                    _projectileArr.push(new Wep7Projectile());
                }// end else if
            }
            else if (param6 == "payload")
            {
                _projectileArr.push(new Wep2aProjectile(param7));
            }
            else if (param6 == "aster")
            {
                _projectileArr.push(new Wep3Projectile());
            }
            else if (param6 == "mine")
            {
                _projectileArr.push(new MineProjectile());
            }
            else if (param6 == "unit")
            {
                _projectileArr.push(new UnitProjectile());
                _projectileArr[_projectileArr.length-1].diameter = 30;
            }// end else if
            if (!(param6 == "bullet" && _176c == 3))
            {
                _1778.addChild(_projectileArr[_projectileArr.length-1]);
                _projectileArr[_projectileArr.length-1].angleVelocity = param5;
                _projectileArr[_projectileArr.length-1].x = param1;
                _projectileArr[_projectileArr.length-1].y = param2;
                _projectileArr[_projectileArr.length-1].oldX = param1;
                _projectileArr[_projectileArr.length-1].oldY = param2;
                _projectileArr[_projectileArr.length-1].momX = param3;
                _projectileArr[_projectileArr.length-1].momY = param4;
            }// end if
            return;
        }// end function

        public function _17a7(param1, param2, param3)
        {
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            _1737.push(new ShieldNode());
            _1778.addChild(_1737[_1737.length-1]);
            _1737[_1737.length-1].x = param1 + 50 * Math.sin(-param3 * (Math.PI / 180));
            _1737[_1737.length-1].y = param2 + 50 * Math.cos(-param3 * (Math.PI / 180));
            _1737.push(new ShieldNode());
            _1778.addChild(_1737[_1737.length-1]);
            _1737[_1737.length-1].x = param1 + 50 * Math.sin((180 - param3) * (Math.PI / 180));
            _1737[_1737.length-1].y = param2 + 50 * Math.cos((180 - param3) * (Math.PI / 180));
            _loc_4 = _1737[_1737.length - 2].x - _1737[_1737.length-1].x;
            _loc_5 = _1737[_1737.length - 2].y - _1737[_1737.length-1].y;
            _loc_6 = Math.sqrt(_loc_4 * _loc_4 + _loc_5 * _loc_5);
            _loc_7 = Math.atan2(_loc_5, _loc_4) - Math.PI / 2;
            _1737[_1737.length-1].shieldLine = new ShieldLine();
            _1737[_1737.length-1].shieldLine.scaleY = _loc_6 / 100;
            _1737[_1737.length-1].shieldLine.rotation = _loc_7 * (180 / Math.PI);
            _175c.addChild(_1737[_1737.length-1].shieldLine);
            _1737[_1737.length-1].shieldLine.x = _1737[_1737.length-1].x;
            _1737[_1737.length-1].shieldLine.y = _1737[_1737.length-1].y;
            return;
        }// end function

        public function doQuit(param1:MouseEvent = null)
        {
            var _loc_2:int;
            _17bb();
            if (_17210 == "gameover")
            {
                MovieClip(root).doTransition("exitgame");
            }
            else
            {
                _loc_2 = Math.floor(MovieClip(root).achievementsInfo.levelsUnlocked-- / 5) + 1;
                if (_loc_2 > 5)
                {
                    _loc_2 = 5;
                }// end if
                MovieClip(root).doTransition("levelselect" + _loc_2);
            }// end else if
            return;
        }// end function

        public function _17b1(param1:MouseEvent)
        {
            var _loc_2:Number;
            var _loc_3:Number;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:Boolean;
            var _loc_8:int;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            _loc_2 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
            _loc_3 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
            _loc_4 = _loc_2 - mouseX;
            _loc_5 = _loc_3 - mouseY;
            _loc_6 = Math.sqrt(_loc_4 * _loc_4 + _loc_5 * _loc_5);
            if (_17210 == "shoot" && myTeamsTurn && !_17a2[_17be].isWalking && _loc_6 < 30 || _176c == 3 || _176c == 9 || _176c == 10 && !_177f && !(param1.target is SimpleButton) && !(param1.target is WepIcon))
            {
                _17c6.gotoAndStop(34);
                if (panelWeps.shown)
                {
                    panelWeps.hideIt();
                }// end if
                if (_176c == 9)
                {
                    _loc_7 = false;
                    _loc_8 = 0;
                    while (_loc_8 < _plantes.length)
                    {
                        // label
                        _loc_9 = mouseX - _plantes[_loc_8].x;
                        _loc_10 = mouseY - _plantes[_loc_8].y;
                        _loc_11 = Math.sqrt(_loc_9 * _loc_9 + _loc_10 * _loc_10);
                        if (_loc_11 < (16 + _plantes[_loc_8].diameter) / 2)
                        {
                            _loc_7 = true;
                        }// end if
                        _loc_8++;
                    }// end while
                    if (true)
                    {
                        _1778.addChild(_173f);
                        aiming = true;
                        stage.removeEventListener(MouseEvent.MOUSE_DOWN, _17b1);
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, _177a);
                        stage.addEventListener(MouseEvent.MOUSE_UP, _1747);
                        _1737.push(new ShieldNode());
                        _1778.addChild(_1737[_1737.length-1]);
                        _173f.x = mouseX;
                        _173f.y = mouseY;
                        _1737[_1737.length-1].x = mouseX;
                        _1737[_1737.length-1].y = mouseY;
                    }// end if
                }
                else if (_176c == 10)
                {
                    stage.removeEventListener(MouseEvent.MOUSE_DOWN, _17b1);
                    stage.addEventListener(MouseEvent.MOUSE_UP, _1747);
                }
                else
                {
                    if (_176c == 3)
                    {
                        _loc_7 = false;
                        _loc_8 = 0;
                        while (_loc_8 < _plantes.length)
                        {
                            // label
                            _loc_9 = mouseX - _plantes[_loc_8].x;
                            _loc_10 = mouseY - _plantes[_loc_8].y;
                            _loc_11 = Math.sqrt(_loc_9 * _loc_9 + _loc_10 * _loc_10);
                            if (_loc_11 < (50 + _plantes[_loc_8].diameter) / 2)
                            {
                                _loc_7 = true;
                            }// end if
                            _loc_8++;
                        }// end while
                    }// end if
                    if (_176c != 3 || !_loc_7)
                    {
                        aiming = true;
                        _1767 = new Point(mouseX, mouseY);
                        _17a2[_17be].changeAnim("aiming" + _176c);
                        stage.removeEventListener(MouseEvent.MOUSE_DOWN, _17b1);
                        stage.addEventListener(MouseEvent.MOUSE_UP, _1747);
                        stage.addEventListener(MouseEvent.MOUSE_MOVE, _177a);
                        _177a();
                        _178e = 2;
                    }// end if
                }// end else if
            }// end else if
            return;
        }// end function

        public function _17b2(param1, param2)
        {
            var _loc_3:*;
            if (param1.graphic)
            {
                _loc_3 = PixelPerfectCollisionDetection.isColliding(param1.hitarea, param2, this, true, 0);
                if (_loc_3 && !(param2 is Wep5Projectile))
                {
                    return _loc_3;
                }// end if
                return false;
            }// end if
            return;
        }// end function

        public function _17b3()
        {
            var _loc_1:int;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            _loc_1 = 0;
            _loc_2 = 0;
            _1749 = 0;
            while (_1749 < teamHealths.length)
            {
                // label
                if (teamHealths[_1749] > 0)
                {
                    _loc_1++;
                    _loc_2 = _1749;
                }// end if
                _1749++;
            }// end while
            if (_loc_1 >= 2 && teamHealths[0] == 0)
            {
                MovieClip(root).lastGameLevel = MovieClip(root).levelSetup.levelID;
                MovieClip(root).lastGameHealth = _loc_3;
                MovieClip(root).lastGameDamage = _1794;
                MovieClip(root).achievementsInfo.stats["damageDone"] = MovieClip(root).achievementsInfo.stats["damageDone"] + _1794;
                if (classicGFX)
                {
                    MovieClip(root).achievementsInfo.stats["originalGFX"] = 1;
                }// end if
                _17210 = "gameover";
                MovieClip(root).msg.addMessage("You Lost!", 0);
                MovieClip(root).lastGameWin = false;
                MovieClip(root).lastGameDraw = false;
            }
            else if (_loc_1 == 1)
            {
                _loc_3 = 0;
                _174a = 0;
                while (_174a < _17a2.length)
                {
                    // label
                    if (_17a2[_174a].team == 0)
                    {
                        _loc_3 = _loc_3 + _17a2[_174a].health;
                    }// end if
                    _loc_4 = 0;
                    if (MovieClip(root).achievementsInfo.aCount >= 40)
                    {
                        _loc_4 = 6;
                    }
                    else if (MovieClip(root).achievementsInfo.aCount >= 32)
                    {
                        _loc_4 = 5;
                    }
                    else if (MovieClip(root).achievementsInfo.aCount >= 24)
                    {
                        _loc_4 = 4;
                    }
                    else if (MovieClip(root).achievementsInfo.aCount >= 16)
                    {
                        _loc_4 = 3;
                    }
                    else if (MovieClip(root).achievementsInfo.aCount >= 8)
                    {
                        _loc_4 = 2;
                    }// end else if
                    _17a2[_174a].danceID = _174a % _loc_4;
                    if (_17a2[_174a].danceID == 0)
                    {
                        _17a2[_174a].changeAnim("cheer");
                    }
                    else if (_17a2[_174a].danceID == 1)
                    {
                        _17a2[_174a].changeAnim("headbang");
                    }
                    else if (_17a2[_174a].danceID == 2)
                    {
                        _17a2[_174a].changeAnim("hands");
                    }
                    else if (_17a2[_174a].danceID == 3)
                    {
                        _17a2[_174a].changeAnim("worm");
                    }
                    else if (_17a2[_174a].danceID == 4)
                    {
                        _17a2[_174a].changeAnim("moonwalk");
                    }
                    else if (_17a2[_174a].danceID == 4)
                    {
                        _17a2[_174a].changeAnim("gunshoot");
                    }// end else if
                    _174a++;
                }// end while
                _1766.removeChild(gameTimer);
                _17210 = "gameover";
                MovieClip(root).lastGameLevel = MovieClip(root).levelSetup.levelID;
                MovieClip(root).lastGameHealth = _loc_3;
                MovieClip(root).lastGameDamage = _1794;
                MovieClip(root).achievementsInfo.stats["damageDone"] = MovieClip(root).achievementsInfo.stats["damageDone"] + _1794;
                if (classicGFX)
                {
                    MovieClip(root).achievementsInfo.stats["originalGFX"] = 1;
                }// end if
                if (_loc_2 == 0)
                {
                    MovieClip(root).msg.addMessage("Red Team Wins", _loc_2);
                    _cam.setTarget(_17a2[0], _175b, _177c, _1795, _1797);
                    MovieClip(root).lastGameWin = true;
                    MovieClip(root).lastGameDraw = false;
                }
                else if (_loc_2 == 1)
                {
                    MovieClip(root).msg.addMessage("Blue Team Wins", _loc_2);
                    _cam.setTarget(_17a2[0], _175b, _177c, _1795, _1797);
                    MovieClip(root).lastGameWin = false;
                    MovieClip(root).lastGameDraw = false;
                }
                else if (_loc_2 == 2)
                {
                    MovieClip(root).msg.addMessage("Green Team Wins", _loc_2);
                    _cam.setTarget(_17a2[0], _175b, _177c, _1795, _1797);
                    MovieClip(root).lastGameWin = false;
                    MovieClip(root).lastGameDraw = false;
                }
                else if (_loc_2 == 3)
                {
                    MovieClip(root).msg.addMessage("Yellow Team Wins", _loc_2);
                    _cam.setTarget(_17a2[0], _175b, _177c, _1795, _1797);
                    MovieClip(root).lastGameWin = false;
                    MovieClip(root).lastGameDraw = false;
                }// end else if
                if (_loc_2 == 0 && MovieClip(root).levelSetup.levelID == MovieClip(root).achievementsInfo.levelsUnlocked)
                {
                    MovieClip(root).achievementsInfo.levelsUnlocked = MovieClip(root).levelSetup.levelID + 1;
                    _loc_5 = Math.floor(MovieClip(root).levelSetup.levelID / 5);
                    if (_loc_5 > MovieClip(root).achievementsInfo.stats["highestSectorCompleted"])
                    {
                        MovieClip(root).achievementsInfo.stats["highestSectorCompleted"] = _loc_5;
                    }// end if
                    MovieClip(root).achievementsInfo.checkWepsUnlocked();
                }// end if
            }
            else if (_loc_1 == 0)
            {
                MovieClip(root).lastGameLevel = MovieClip(root).levelSetup.levelID;
                MovieClip(root).lastGameHealth = _loc_3;
                MovieClip(root).lastGameDamage = _1794;
                MovieClip(root).achievementsInfo.stats["damageDone"] = MovieClip(root).achievementsInfo.stats["damageDone"] + _1794;
                if (classicGFX)
                {
                    MovieClip(root).achievementsInfo.stats["originalGFX"] = 1;
                }// end if
                _17210 = "gameover";
                MovieClip(root).msg.addMessage("Everyone\'s Dead! Draw!", 0);
                MovieClip(root).lastGameWin = false;
                MovieClip(root).lastGameDraw = true;
            }// end else if
            return;
        }// end function

        public function _17b4()
        {
            _wepIcon.alpha = 0;
            _wepIcon.mouseEnabled = false;
            _17c1();
            panelWeps.alpha = 0;
            panelWeps.mouseEnabled = false;
            panelWeps.mouseChildren = false;
            return;
        }// end function

        public function _17b7(param1, param2, param3, param4)
        {
            var _loc_5:BlurFilter;
            if (param4 == "zap")
            {
                _17ce.push(new UnitZap());
                if (MovieClip(root).sfx)
                {
                    MovieClip(root).soundmanager.sound_zap.gotoAndPlay(2);
                }// end if
            }
            else if (param4 == "burn")
            {
                _17ce.push(new UnitBurn());
                _loc_5 = new BlurFilter(8, 8, 3);
                _17ce[_17ce.length-1].filters = [_loc_5];
                if (MovieClip(root).sfx)
                {
                    MovieClip(root).soundmanager.sound_burn.gotoAndPlay(2);
                }// end if
            }
            else if (param4 == "spark")
            {
                _17ce.push(new Spark());
                if (MovieClip(root).sfx)
                {
                    MovieClip(root).soundmanager.sound_bounce.gotoAndPlay(2);
                }// end if
            }
            else if (param3 <= 0.5)
            {
                _17ce.push(new Explosion0());
                if (MovieClip(root).sfx)
                {
                    MovieClip(root).soundmanager.sound_explosion.gotoAndPlay(2);
                }// end if
            }
            else
            {
                _17ce.push(new Explosion1());
                if (MovieClip(root).sfx)
                {
                    MovieClip(root).soundmanager.sound_explosion.gotoAndPlay(2);
                }// end else if
            }// end else if
            _17ce[_17ce.length-1].scaleX = param3;
            _17ce[_17ce.length-1].scaleY = param3;
            _17a9.addChild(_17ce[_17ce.length-1]);
            _17ce[_17ce.length-1].x = param1;
            _17ce[_17ce.length-1].y = param2;
            return;
        }// end function

        public function _17b8(param1)
        {
            var _loc_2:int;
            _loc_2 = _projectileArr.indexOf(param1);
            _1778.removeChild(param1);
            _projectileArr.splice(_loc_2, 1);
            return;
        }// end function

        public function _17b9(param1, param2)
        {
            var _loc_3:*;
            if (!param1.isSun)
            {
                _loc_3 = PixelPerfectCollisionDetection.isColliding(param1.shape2, param2, this, true, 0);
            }
            else
            {
                _loc_3 = PixelPerfectCollisionDetection.isColliding(param1, param2, this, true, 0);
            }// end else if
            if (_loc_3)
            {
                return _loc_3;
            }// end if
            return false;
        }// end function

        public function _17ba()
        {
            var _loc_1:int;
            if (!MovieClip(root).achievementsInfo.infAmmo)
            {
                _loc_1 = 1;
                while (_loc_1 < 10)
                {
                    // label
                    panelWeps.panel["wep" + _loc_1 + "stock"].text = _17610[_loc_1].toString();
                    panelWeps.panel["wep" + _loc_1 + "stock"].mouseEnabled = false;
                    _loc_1++;
                }// end while
            }
            else
            {
                _loc_1 = 1;
                while (_loc_1 < 10)
                {
                    // label
                    panelWeps.panel["wep" + _loc_1 + "stock"].text = "";
                    panelWeps.panel["wep" + _loc_1 + "stock"].mouseEnabled = false;
                    panelWeps.panel["wep" + _loc_1 + "inf"].gotoAndStop(2);
                    panelWeps.panel["wep" + _loc_1 + "inf"].mouseEnabled = false;
                    _loc_1++;
                }// end while
            }// end else if
            return;
        }// end function

        public function _17bb()
        {
            panelWeps.panel.wep1.removeEventListener(MouseEvent.MOUSE_UP, _1761);
            if (MovieClip(root).achievementsInfo.wepsUnlocked[1])
            {
                panelWeps.panel.wep2.removeEventListener(MouseEvent.MOUSE_UP, _1765);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[2])
            {
                panelWeps.panel.wep4.removeEventListener(MouseEvent.MOUSE_UP, _176d);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[3])
            {
                panelWeps.panel.wep6.removeEventListener(MouseEvent.MOUSE_UP, _1777);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[4])
            {
                panelWeps.panel.wep8.removeEventListener(MouseEvent.MOUSE_UP, _178f);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[5])
            {
                panelWeps.panel.wep9.removeEventListener(MouseEvent.MOUSE_UP, _176b);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[6])
            {
                panelWeps.panel.wep5.removeEventListener(MouseEvent.MOUSE_UP, _176e);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[7])
            {
                panelWeps.panel.wep10.removeEventListener(MouseEvent.MOUSE_UP, _173e);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[8])
            {
                panelWeps.panel.wep7.removeEventListener(MouseEvent.MOUSE_UP, _1769);
            }// end if
            if (MovieClip(root).achievementsInfo.wepsUnlocked[9])
            {
                panelWeps.panel.wep3.removeEventListener(MouseEvent.MOUSE_UP, _1762);
            }// end if
            _wepIcon.removeEventListener(MouseEvent.MOUSE_DOWN, wepIconClicked);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, _1728);
            stage.removeEventListener(KeyboardEvent.KEY_UP, _1744);
            if (stage.hasEventListener(MouseEvent.MOUSE_UP))
            {
                stage.removeEventListener(MouseEvent.MOUSE_UP, _1747);
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, _177a);
            }// end if
            if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, _17b1);
            }// end if
            removeEventListener(Event.ENTER_FRAME, mainLoop);
            return;
        }// end function

        public function _17bc()
        {
            _1785.graphics.clear();
            return;
        }// end function

        public function unitJiggleFix()
        {
            var _loc_1:int;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:int;
            var _loc_5:int;
            var _loc_6:int;
            _loc_1 = 0;
            while (_loc_1 < _17a2.length)
            {
                // label
                _loc_4 = _17a2[_loc_1].positionPlanet;
                _loc_5 = 0;
                while (_loc_5 < _plantes[_loc_4].shapeArray.length)
                {
                    // label
                    _loc_6 = 0;
                    while (_loc_6 < _plantes[_loc_4].shapeArray[_loc_5].length)
                    {
                        // label
                        if (_plantes[_loc_4].shapeArray[_loc_5][_loc_6].x == _17a2[_loc_1].positionElementX && _plantes[_loc_4].shapeArray[_loc_5][_loc_6].y == _17a2[_loc_1].positionElementY)
                        {
                            _17a2[_loc_1].positionElement = _loc_6;
                            _17a2[_loc_1].positionShape = _loc_5;
                        }// end if
                        _loc_6++;
                    }// end while
                    _loc_5++;
                }// end while
                _loc_1++;
            }// end while
            _loc_2 = 0;
            while (_loc_2 < _mines.length)
            {
                // label
                _loc_4 = _mines[_loc_2].positionPlanet;
                _loc_5 = 0;
                while (_loc_5 < _plantes[_loc_4].shapeArray.length)
                {
                    // label
                    _loc_6 = 0;
                    while (_loc_6 < _plantes[_loc_4].shapeArray[_loc_5].length)
                    {
                        // label
                        if (_plantes[_loc_4].shapeArray[_loc_5][_loc_6].x == _mines[_loc_2].positionElementX && _plantes[_loc_4].shapeArray[_loc_5][_loc_6].y == _mines[_loc_2].positionElementY)
                        {
                            _mines[_loc_2].positionElement = _loc_6;
                        }// end if
                        _loc_6++;
                    }// end while
                    _loc_5++;
                }// end while
                _loc_2++;
            }// end while
            _loc_3 = 0;
            while (_loc_3 < _17a6.length)
            {
                // label
                _loc_4 = _17a6[_loc_3].positionPlanet;
                _loc_5 = 0;
                while (_loc_5 < _plantes[_loc_4].shapeArray.length)
                {
                    // label
                    _loc_6 = 0;
                    while (_loc_6 < _plantes[_loc_4].shapeArray[_loc_5].length)
                    {
                        // label
                        if (_plantes[_loc_4].shapeArray[_loc_5][_loc_6].x == _17a6[_loc_3].positionElementX && _plantes[_loc_4].shapeArray[_loc_5][_loc_6].y == _17a6[_loc_3].positionElementY)
                        {
                            _17a6[_loc_3].positionElement = _loc_6;
                        }// end if
                        _loc_6++;
                    }// end while
                    _loc_5++;
                }// end while
                _loc_3++;
            }// end while
            return;
        }// end function

        public function _17bf(param1, param2, param3, param4)
        {
            _plantes.push(new Planet());
            _175c.addChild(_plantes[_plantes.length-1]);
            if (param4 == 1)
            {
                _plantes[_plantes.length-1].isSun = true;
            }// end if
            _plantes[_plantes.length-1].diameter = param1;
            _plantes[_plantes.length-1].x = param2;
            _plantes[_plantes.length-1].y = param3;
            _plantes[_plantes.length-1].GFXID = param4;
            _plantes[_plantes.length-1].classicGFX = classicGFX;
            _plantes[_plantes.length-1].updatePlanet();
            return;
        }// end function

        public function _17c1(param1:MouseEvent = null)
        {
            if (panelWeps.currentFrame == 11)
            {
                panelWeps.removeEventListener(MouseEvent.MOUSE_UP, _17c1);
                panelWeps.addEventListener(MouseEvent.MOUSE_UP, _1739);
                panelWeps.gotoAndPlay(12);
            }// end if
            return;
        }// end function

        public function _17c3()
        {
            if (_176f <= MovieClip(root).levelSetup.criteria[0])
            {
                _17ab.medalCrit.text = "Win in " + MovieClip(root).levelSetup.criteria[0] + " turns for Gold";
            }
            else if (_176f <= MovieClip(root).levelSetup.criteria[1])
            {
                _17ab.medalCrit.text = "Win in " + MovieClip(root).levelSetup.criteria[1] + " turns for Silver";
            }
            else
            {
                _17ab.medalCrit.text = "Win for Bronze";
            }// end else if
            _17ab.turnNumber.text = _176f.toString();
            return;
        }// end function

        public function _17c4(param1, param2)
        {
            var _loc_3:*;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:int;
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:int;
            var _loc_12:Number;
            var _loc_13:Number;
            var _loc_14:Number;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:Number;
            var _loc_18:*;
            var _loc_19:*;
            var _loc_20:*;
            var _loc_21:int;
            var _loc_22:int;
            var _loc_23:Number;
            var _loc_24:Number;
            var _loc_25:Number;
            _17a2[param1].healthDisplay.hideHealth();
            _17a2[param1].scaleX = -1;
            _17a2[param1].isWalking = true;
            _1746 = param2;
            _loc_3 = _17a2[param1].x;
            _loc_4 = _17a2[param1].y;
            while (_1746 > 0)
            {
                // label
                _loc_8 = _17a2[param1].positionPlanet;
                _loc_9 = _17a2[param1].positionShape;
                _loc_10 = _17a2[param1].positionElement;
                if (--_17a2[param1].positionElement < 0)
                {
                    _loc_11 = --_17a2[param1].positionElement + _plantes[_loc_8].shapeArray[_loc_9].length;
                }// end if
                _loc_12 = _17a2[param1].positionPlace;
                _loc_13 = _plantes[_loc_8].shapeArray[_loc_9][_loc_11].x - _plantes[_loc_8].shapeArray[_loc_9][_loc_10].x;
                _loc_14 = _plantes[_loc_8].shapeArray[_loc_9][_loc_11].y - _plantes[_loc_8].shapeArray[_loc_9][_loc_10].y;
                _loc_15 = Math.sqrt(_loc_13 * _loc_13 + _loc_14 * _loc_14);
                _loc_16 = Math.atan2(_plantes[_loc_8].shapeArray[_loc_9][_loc_10].y - _plantes[_loc_8].shapeArray[_loc_9][(_17a2[param1].positionElement + 1) % _plantes[_loc_8].shapeArray[_loc_9].length].y, _plantes[_loc_8].shapeArray[_loc_9][_loc_10].x - _plantes[_loc_8].shapeArray[_loc_9][(_17a2[param1].positionElement + 1) % _plantes[_loc_8].shapeArray[_loc_9].length].x);
                _loc_17 = _loc_16 * (180 / Math.PI);
                if (_loc_17 > 180)
                {
                    _loc_17 = _loc_17 - 360;
                }
                else if (_loc_17 < -180)
                {
                    _loc_17 = _loc_17 + 360;
                }// end else if
                if (_17a2[param1].rotation != _loc_17)
                {
                    _loc_18 = _17a2[param1].rotation - _loc_17;
                    if (_loc_18 < -180)
                    {
                        _loc_18 = _loc_18 + 360;
                    }
                    else if (_loc_18 > 180)
                    {
                        _loc_18 = _loc_18 - 360;
                    }// end else if
                    _loc_19 = _loc_18 / _17c2;
                    if (Math.abs(_loc_19) < _1746)
                    {
                        _1746 = _1746 - Math.abs(_loc_19);
                        _17a2[param1].rotation = _loc_17;
                    }
                    else
                    {
                        _loc_20 = _loc_17 - _17a2[param1].rotation;
                        if (_loc_20 > 180)
                        {
                            _loc_20 = _loc_20 - 360;
                        }
                        else if (_loc_20 < -180)
                        {
                            _loc_20 = _loc_20 + 360;
                        }// end else if
                        if (_loc_20 < 0)
                        {
                            _17a2[param1].rotation = _17a2[param1].rotation - _1746 * _17c2;
                        }
                        else
                        {
                            _17a2[param1].rotation = _17a2[param1].rotation + _1746 * _17c2;
                        }// end else if
                        _1746 = 0;
                    }// end else if
                    _17410(param1, false);
                }
                else if (_loc_12 - _1746 <= 0)
                {
                    _loc_21 = _17a2[param1].positionElement;
                    if (--_17a2[param1].positionElement < 0)
                    {
                        _loc_22 = --_17a2[param1].positionElement + _plantes[_loc_8].shapeArray[_loc_9].length;
                    }// end if
                    _loc_23 = _plantes[_loc_8].shapeArray[_loc_9][_loc_21].x - _plantes[_loc_8].shapeArray[_loc_9][_loc_22].x;
                    _loc_24 = _plantes[_loc_8].shapeArray[_loc_9][_loc_21].y - _plantes[_loc_8].shapeArray[_loc_9][_loc_22].y;
                    _loc_25 = Math.sqrt(_loc_23 * _loc_23 + _loc_24 * _loc_24);
                    _17a2[param1].positionElement = _loc_11;
                    _17a2[param1].positionElementX = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][_loc_11].x;
                    _17a2[param1].positionElementY = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][_loc_11].y;
                    _17a2[param1].positionPlace = _loc_25;
                    _1746 = _1746 - _loc_12;
                    _17410(param1, false);
                }
                else
                {
                    _17a2[param1].positionPlace = _17a2[param1].positionPlace - _1746;
                    _1746 = 0;
                    _17410(param1, false);
                }// end else if
                if (_17a2[param1].positionElement >= _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape].length)
                {
                    _17a2[param1].positionElement = 0;
                    _17a2[param1].positionElementX = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][0].x;
                    _17a2[param1].positionElementY = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][0].y;
                }// end if
            }// end while
            _loc_5 = _loc_3 - _17a2[param1].x;
            _loc_6 = _loc_4 - _17a2[param1].y;
            _loc_7 = Math.sqrt(_loc_5 * _loc_5 + _loc_6 * _loc_6);
            if (_17a2[param1].animState != "walk" && _17210 != "gameover")
            {
                _17a2[param1].changeAnim("walk");
            }// end if
            return;
        }// end function

        public function _17c5(param1, param2, param3, param4)
        {
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            var _loc_12:*;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_16:*;
            var _loc_17:int;
            var _loc_18:*;
            var _loc_19:*;
            _17a2.push(new Unit());
            _17a2[_17a2.length-1].addEventListener(MouseEvent.MOUSE_OVER, _172f);
            _17a2[_17a2.length-1].addEventListener(MouseEvent.MOUSE_OUT, _172c);
            _1734.addChild(_17a2[_17a2.length-1]);
            if (param4)
            {
                do
                {
                    // label
                    _loc_5 = 0;
                    do
                    {
                        // label
                        _loc_7 = Math.floor(Math.random() * _plantes.length);
                    }while (_plantes[_loc_7].isSun)
                    _loc_6 = Math.floor(Math.random() * _plantes[_loc_7].shapeArray[0].length);
                    _17a2[_17a2.length-1].positionPlanet = _loc_7;
                    _17a2[_17a2.length-1].positionShape = 0;
                    _17a2[_17a2.length-1].positionElement = _loc_6;
                    _17a2[_17a2.length-1].positionElementX = _plantes[_loc_7].shapeArray[0][_loc_6].x;
                    _17a2[_17a2.length-1].positionElementY = _plantes[_loc_7].shapeArray[0][_loc_6].y;
                    _17410(_17a2.length-1, true);
                    if (_17a2.length > 1)
                    {
                        _174a = 0;
                        while (_174a < _17a2.length-1)
                        {
                            // label
                            _loc_8 = _17a2[_17a2.length-1].x - _17a2[_174a].x;
                            _loc_9 = _17a2[_17a2.length-1].y - _17a2[_174a].y;
                            _loc_10 = _loc_8 * _loc_8 + _loc_9 * _loc_9;
                            if (_loc_10 < 3000)
                            {
                            }// end if
                            _174a++;
                        }// end while
                    }// end if
                }while (_loc_5++ > 0)
                _17a2[_17a2.length-1].rotation = Math.atan2(_plantes[_loc_7].shapeArray[0][_loc_6].y - _plantes[_loc_7].shapeArray[0][(_loc_6 + 1) % _plantes[_loc_7].shapeArray[0].length].y, _plantes[_loc_7].shapeArray[0][_loc_6].x - _plantes[_loc_7].shapeArray[0][(_loc_6 + 1) % _plantes[_loc_7].shapeArray[0].length].x) * (180 / Math.PI);
            }
            else
            {
                if (param2 < 0)
                {
                    param2 = param2 + 360;
                }// end if
                if (param2 > 360)
                {
                    param2 = param2 - 360;
                }// end if
                _17a2[_17a2.length-1].positionPlanet = param1;
                _17a2[_17a2.length-1].positionShape = 0;
                graphics.lineStyle(2, 16711680, 1);
                _loc_11 = _plantes[param1].x;
                _loc_12 = _plantes[param1].y;
                _loc_13 = _plantes[param1].x - 200 * Math.sin((90 - param2) * (Math.PI / 180));
                _loc_14 = _plantes[param1].y - 200 * Math.cos((90 - param2) * (Math.PI / 180));
                _loc_15 = new Point(_loc_11 - _plantes[param1].x, _loc_12 - _plantes[param1].y);
                _loc_16 = new Point(_loc_13 - _plantes[param1].x, _loc_14 - _plantes[param1].y);
                _loc_17 = 0;
                while (_loc_17 < _plantes[param1].shapeArray[0].length)
                {
                    // label
                    _loc_18 = new Point(_plantes[param1].shapeArray[0][_loc_17].x, _plantes[param1].shapeArray[0][_loc_17].y);
                    _loc_19 = new Point(_plantes[param1].shapeArray[0][(_loc_17 + 1) % _plantes[param1].shapeArray[0].length].x, _plantes[param1].shapeArray[0][(_loc_17 + 1) % _plantes[param1].shapeArray[0].length].y);
                    if (_plantes[_1725].lineIntersectLine(_loc_15, _loc_16, _loc_18, _loc_19, true))
                    {
                        _17a2[_17a2.length-1].positionElement = _loc_17;
                        _17a2[_17a2.length-1].positionElementX = _plantes[_17a2[_17a2.length-1].positionPlanet].shapeArray[_17a2[_17a2.length-1].positionShape][_loc_17].x;
                        _17a2[_17a2.length-1].positionElementY = _plantes[_17a2[_17a2.length-1].positionPlanet].shapeArray[_17a2[_17a2.length-1].positionShape][_loc_17].y;
                    }// end if
                    _loc_17++;
                }// end while
                _17410(_17a2.length-1, true);
            }// end else if
            _17a2[_17a2.length-1].team = param3;
            _17a2[_17a2.length-1].timeSince = _178c[param3];
            if (_17a2.length == 1)
            {
                _17a2[_17a2.length-1].timeSince = 0;
            }// end if
            var _loc_20:* = _178c;
            var _loc_21:* = param3;
            _loc_20[_loc_21] = _178c[param3]--;
            _17a2[_17a2.length-1].updateCol();
            _17a2[_17a2.length-1].graphic.gotoAndPlay(Math.ceil(Math.random() * _17a2[_17a2.length-1].graphic.totalFrames));
            return;
        }// end function

        public function _17ca(param1, param2, param3, param4, param5)
        {
            var _loc_6:int;
            var _loc_7:int;
            var _loc_8:int;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            var _loc_12:*;
            var _loc_13:*;
            var _loc_14:*;
            var _loc_15:*;
            var _loc_16:*;
            var _loc_17:Number;
            var _loc_18:Number;
            var _loc_19:Number;
            var _loc_20:Number;
            var _loc_21:Number;
            var _loc_22:Number;
            var _loc_23:Number;
            var _loc_24:*;
            var _loc_25:*;
            var _loc_26:*;
            var _loc_27:Number;
            var _loc_28:Number;
            if (param5 == "proj" || param5 == "unit")
            {
                expSize = _projectileArr[param3].expSize;
                shake = _projectileArr[param3].shake;
                _projectileArr[param3].removeMe = true;
            }
            else if (param5 == "mine")
            {
                expSize = _mines[param3].expSize;
                shake = _mines[param3].shake;
                _mines[param3].removeMe = true;
            }
            else if (param5 == "dead")
            {
                expSize = 60;
                shake = 4;
                if (param3 != -1)
                {
                    _17a2[param3].removeMe = true;
                }// end else if
            }// end else if
            _17b7(param1, param2, expSize / 60, "");
            if (param4 > -1)
            {
                if (!_plantes[param4].isSun)
                {
                    _plantes[param4].removeChunk(param1, param2, expSize);
                    _plantes[param4].findNewCenter();
                }// end if
            }
            else
            {
                _loc_8 = 0;
                while (_loc_8 < _plantes.length)
                {
                    // label
                    _loc_9 = param1 - _plantes[_loc_8].x;
                    _loc_10 = param2 - _plantes[_loc_8].y;
                    _loc_11 = Math.sqrt(_loc_9 * _loc_9 + _loc_10 * _loc_10);
                    if (!_plantes[_loc_8].isSun && _loc_11 < (_plantes[_loc_8].diameter + expSize) / 2)
                    {
                        _plantes[_loc_8].removeChunk(param1, param2, expSize);
                        _plantes[_loc_8].findNewCenter();
                    }// end if
                    _loc_8++;
                }// end while
            }// end else if
            while (_loc_8-- >= 0)
            {
                // label
                _loc_12 = _17a6[_17a6.length-1].x - param1;
                _loc_13 = _17a6[_loc_8].y - param2;
                if (!_17a6[_loc_8].removeMe && _loc_12 * _loc_12 + _loc_13 * _loc_13 < expSize * expSize)
                {
                    _17a6[_loc_8].removeMe = true;
                    _17ca(_17a6[_loc_8].x, _17a6[_loc_8].y, -1, -1, "dead");
                }// end if
            }// end while
            while (_loc_6-- >= 0)
            {
                // label
                _loc_14 = _mines[_mines.length-1].x - param1;
                _loc_15 = _mines[_loc_6].y - param2;
                if (param5 == "mine" && param3 != _loc_6 && !_mines[_loc_6].removeMe && _loc_14 * _loc_14 + _loc_15 * _loc_15 < expSize * expSize)
                {
                    _mines[_loc_6].removeMe = true;
                    _loc_16 = Math.sqrt(_loc_14 * _loc_14 + _loc_15 * _loc_15);
                    _loc_17 = Math.atan2(_loc_15, _loc_14);
                    _loc_18 = _loc_17 * (180 / Math.PI);
                    _loc_19 = (expSize - _loc_16) / 2;
                    _loc_20 = _loc_19 * -Math.sin((-1 * (_loc_18 - 180) + 90) * (Math.PI / 180)) * 1.5;
                    _loc_21 = _loc_19 * -Math.cos((-1 * (_loc_18 - 180) + 90) * (Math.PI / 180)) * 1.5;
                    _17910(_mines[_loc_6].x, _mines[_loc_6].y, _loc_20, _loc_21, 10, "mine", null);
                    _projectileArr[_projectileArr.length-1].timeTilPrimed = _mines[_loc_6].timeTilPrimed;
                    _projectileArr[_projectileArr.length-1].timeTilBoom = _mines[_loc_6].timeTilBoom;
                    _projectileArr[_projectileArr.length-1].activated = _mines[_loc_6].activated;
                    _projectileArr[_projectileArr.length-1].gotoAndStop(2);
                }// end if
            }// end while
            while (_loc_7-- >= 0)
            {
                // label
                if (param5 != "dead" || param5 == "dead" && _17a2.length-1 != param3 && !_17a2[_loc_7].removeMe)
                {
                    _loc_22 = _17a2[_loc_7].x + 16 * Math.sin((180 - _17a2[_loc_7].rotation) * (Math.PI / 180));
                    _loc_23 = _17a2[_loc_7].y + 16 * Math.cos((180 - _17a2[_loc_7].rotation) * (Math.PI / 180));
                    _loc_24 = _loc_22 - param1;
                    _loc_25 = _loc_23 - param2;
                    if (_loc_24 * _loc_24 + _loc_25 * _loc_25 < expSize * expSize && !_17a2[_loc_7].removeMe)
                    {
                        _loc_26 = Math.sqrt(_loc_24 * _loc_24 + _loc_25 * _loc_25);
                        if (_loc_7 == _17be && gameTimer.timeLeft > 0)
                        {
                            gameTimer.timeLeft = 0;
                            _17210 = "sim";
                        }// end if
                        _17a2[_loc_7].removeMe = true;
                        if (param5 == "proj" || param5 == "unit" && myTeamsTurn)
                        {
                            if (_projectileArr[param3].reflected)
                            {
                                MovieClip(root).achievementsInfo.stats["shieldRebounds"] = 1;
                            }// end if
                            if (MovieClip(root).achievementsInfo.stats["longestShot"] < _projectileArr[param3].distance)
                            {
                                MovieClip(root).achievementsInfo.stats["longestShot"] = Math.round(_projectileArr[param3].distance);
                            }// end if
                            if (MovieClip(root).achievementsInfo.stats["highestMulti"] < _projectileArr[param3].multi)
                            {
                                MovieClip(root).achievementsInfo.stats["highestMulti"] = _projectileArr[param3].multi;
                            }// end if
                        }// end if
                        _loc_17 = Math.atan2(_loc_25, _loc_24);
                        _loc_18 = _loc_17 * (180 / Math.PI);
                        _loc_19 = (expSize - _loc_26) / 2;
                        _loc_20 = _loc_19 * -Math.sin((-1 * (_loc_18 - 180) + 90) * (Math.PI / 180)) * 1.5;
                        _loc_21 = _loc_19 * -Math.cos((-1 * (_loc_18 - 180) + 90) * (Math.PI / 180)) * 1.5;
                        if (_17210 != "shoot" && _17210 != "sim")
                        {
                            _17210 = "sim";
                        }// end if
                        _loc_27 = Math.random() * 7 + 3;
                        if (Math.random() <= 0.5)
                        {
                            _loc_27 = _loc_27 * -1;
                        }// end if
                        _17910(_loc_22, _loc_23, _loc_20, _loc_21, _loc_27, "unit", null);
                        _projectileArr[_projectileArr.length-1].maxHealth = _17a2[_loc_7].maxHealth;
                        _projectileArr[_projectileArr.length-1].accuracy = _17a2[_loc_7].accuracy;
                        _projectileArr[_projectileArr.length-1].unitName = _17a2[_loc_7].unitName;
                        _projectileArr[_projectileArr.length-1].health = _17a2[_loc_7].health;
                        _projectileArr[_projectileArr.length-1].killReg = _17a2[_loc_7].killReg;
                        _projectileArr[_projectileArr.length-1].updateMass();
                        _projectileArr[_projectileArr.length-1].team = _17a2[_loc_7].team;
                        _projectileArr[_projectileArr.length-1].timeSince = _17a2[_loc_7].timeSince;
                        if (param5 == "unit")
                        {
                            if (_projectileArr[_projectileArr.length-1].killReg == -1 && _projectileArr[_projectileArr.length-1].health <= _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi)
                            {
                                if (_projectileArr[_1726] is Wep1Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 1;
                                }
                                else if (_projectileArr[_1726] is Wep2Projectile || _projectileArr[_1726] is Wep2aProjectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 2;
                                }
                                else if (_projectileArr[_1726] is Wep3Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 3;
                                }
                                else if (_projectileArr[_1726] is Wep5Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 5;
                                }
                                else if (_projectileArr[_1726] is Wep7Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 7;
                                }
                                else if (param5 == "mine")
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 8;
                                }// end else if
                            }// end else if
                            _projectileArr[_projectileArr.length-1].damageTaken = _17a2[_loc_7].damageTaken + _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi;
                            if (_17a2[_loc_7].team != 0 && myTeamsTurn)
                            {
                                _1794 = _1794 + _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi;
                            }// end if
                        }
                        else
                        {
                            if (_projectileArr[_projectileArr.length-1].killReg == -1 && _projectileArr[_projectileArr.length-1].health <= Math.round(_loc_19 * _projectileArr[_1726].multi))
                            {
                                if (_projectileArr[_1726] is Wep1Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 1;
                                }
                                else if (_projectileArr[_1726] is Wep2Projectile || _projectileArr[_1726] is Wep2aProjectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 2;
                                }
                                else if (_projectileArr[_1726] is Wep3Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 3;
                                }
                                else if (_projectileArr[_1726] is Wep5Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 5;
                                }
                                else if (_projectileArr[_1726] is Wep7Projectile)
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 7;
                                }
                                else if (param5 == "mine")
                                {
                                    _projectileArr[_projectileArr.length-1].killReg = 8;
                                }// end else if
                            }// end else if
                            _loc_28 = (expSize - _loc_26) / expSize * (_projectileArr[_1726].maxDamage * 2);
                            if (_loc_28 > _projectileArr[_1726].maxDamage)
                            {
                                _loc_28 = _projectileArr[_1726].maxDamage;
                            }// end if
                            _projectileArr[_projectileArr.length-1].damageTaken = _17a2[_loc_7].damageTaken + Math.round(_loc_28 * _projectileArr[_1726].multi);
                            if (_17a2[_loc_7].team != 0 && myTeamsTurn)
                            {
                                _1794 = _1794 + Math.round(_loc_19 * _projectileArr[_1726].multi);
                            }// end if
                        }// end else if
                        _projectileArr[_projectileArr.length-1].poisoned = _17a2[_loc_7].poisoned;
                        _projectileArr[_projectileArr.length-1].updateCol();
                    }// end if
                }// end if
            }// end while
            return;
        }// end function

        public function _17cb(param1, param2)
        {
            var _loc_3:*;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:int;
            var _loc_9:int;
            var _loc_10:int;
            var _loc_11:int;
            var _loc_12:Number;
            var _loc_13:Number;
            var _loc_14:Number;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:Number;
            var _loc_18:*;
            var _loc_19:*;
            var _loc_20:*;
            _17a2[param1].healthDisplay.hideHealth();
            _17a2[param1].scaleX = 1;
            _17a2[param1].isWalking = true;
            _1746 = param2;
            _loc_3 = _17a2[param1].x;
            _loc_4 = _17a2[param1].y;
            while (_1746 > 0)
            {
                // label
                _loc_8 = _17a2[param1].positionPlanet;
                _loc_9 = _17a2[param1].positionShape;
                _loc_10 = _17a2[param1].positionElement;
                _loc_11 = (_17a2[param1].positionElement + 1) % _plantes[_loc_8].shapeArray[_loc_9].length;
                _loc_12 = _17a2[param1].positionPlace;
                _loc_13 = _plantes[_loc_8].shapeArray[_loc_9][_loc_10].x - _plantes[_loc_8].shapeArray[_loc_9][_loc_11].x;
                _loc_14 = _plantes[_loc_8].shapeArray[_loc_9][_loc_10].y - _plantes[_loc_8].shapeArray[_loc_9][_loc_11].y;
                _loc_15 = Math.sqrt(_loc_13 * _loc_13 + _loc_14 * _loc_14);
                _loc_16 = Math.atan2(_plantes[_loc_8].shapeArray[_loc_9][_loc_10].y - _plantes[_loc_8].shapeArray[_loc_9][_loc_11].y, _plantes[_loc_8].shapeArray[_loc_9][_loc_10].x - _plantes[_loc_8].shapeArray[_loc_9][_loc_11].x);
                _loc_17 = _loc_16 * (180 / Math.PI);
                if (_loc_17 > 180)
                {
                    _loc_17 = _loc_17 - 360;
                }
                else if (_loc_17 < -180)
                {
                    _loc_17 = _loc_17 + 360;
                }// end else if
                if (_17a2[param1].rotation != _loc_17)
                {
                    _loc_18 = _17a2[param1].rotation - _loc_17;
                    if (_loc_18 < -180)
                    {
                        _loc_18 = _loc_18 + 360;
                    }// end if
                    _loc_19 = _loc_18 / _17c2;
                    if (Math.abs(_loc_19) < _1746)
                    {
                        _1746 = _1746 - _loc_19;
                        _17a2[param1].rotation = _loc_17;
                    }
                    else
                    {
                        _loc_20 = _loc_17 - _17a2[param1].rotation;
                        if (_loc_20 > 180)
                        {
                            _loc_20 = _loc_20 - 360;
                        }
                        else if (_loc_20 < -180)
                        {
                            _loc_20 = _loc_20 + 360;
                        }// end else if
                        if (_loc_20 < 0)
                        {
                            _17a2[param1].rotation = _17a2[param1].rotation - _1746 * _17c2;
                        }
                        else
                        {
                            _17a2[param1].rotation = _17a2[param1].rotation + _1746 * _17c2;
                        }// end else if
                        _1746 = 0;
                    }// end else if
                    _17410(param1, false);
                }
                else if (_1746 + _loc_12 > _loc_15)
                {
                    _17a2[param1].positionElement = _loc_11;
                    _17a2[param1].positionElementX = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][_loc_11].x;
                    _17a2[param1].positionElementY = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][_loc_11].y;
                    _17a2[param1].positionPlace = 0;
                    _1746 = _1746 - (_loc_15 - _loc_12);
                    _17410(param1, false);
                }
                else
                {
                    _17a2[param1].positionPlace = _17a2[param1].positionPlace + _1746;
                    _1746 = 0;
                    _17410(param1, false);
                }// end else if
                if (_17a2[param1].positionElement >= _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape].length)
                {
                    _17a2[param1].positionElement = 0;
                    _17a2[param1].positionElementX = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][0].x;
                    _17a2[param1].positionElementY = _plantes[_17a2[param1].positionPlanet].shapeArray[_17a2[param1].positionShape][0].y;
                }// end if
            }// end while
            _loc_5 = _loc_3 - _17a2[param1].x;
            _loc_6 = _loc_4 - _17a2[param1].y;
            _loc_7 = Math.sqrt(_loc_5 * _loc_5 + _loc_6 * _loc_6);
            if (_17a2[param1].animState != "walk" && _17210 != "gameover")
            {
                _17a2[param1].changeAnim("walk");
            }// end if
            return;
        }// end function

        public function doUnpause(param1:MouseEvent = null)
        {
            _177f = false;
            MovieClip(root).pausePanel.gotoAndStop(1);
            return;
        }// end function

        public function _17cd()
        {
            var _loc_1:*;
            var _loc_2:int;
            var _loc_3:int;
            var _loc_4:*;
            var _loc_5:*;
            var _loc_6:*;
            var _loc_7:*;
            var _loc_8:*;
            var _loc_9:*;
            var _loc_10:*;
            var _loc_11:*;
            var _loc_12:int;
            var _loc_13:Number;
            var _loc_14:Number;
            var _loc_15:Number;
            var _loc_16:Number;
            var _loc_17:*;
            var _loc_18:*;
            var _loc_19:*;
            var _loc_20:int;
            var _loc_21:int;
            var _loc_22:int;
            var _loc_23:int;
            var _loc_24:*;
            var _loc_25:*;
            var _loc_26:*;
            var _loc_27:int;
            var _loc_28:*;
            var _loc_29:*;
            var _loc_30:int;
            var _loc_31:Point;
            var _loc_32:Point;
            var _loc_33:Point;
            var _loc_34:Point;
            var _loc_35:*;
            var _loc_36:*;
            var _loc_37:*;
            var _loc_38:Point;
            var _loc_39:Point;
            var _loc_40:Point;
            var _loc_41:Point;
            var _loc_42:Point;
            var _loc_43:Array;
            var _loc_44:int;
            var _loc_45:int;
            var _loc_46:int;
            var _loc_47:*;
            var _loc_48:*;
            var _loc_49:*;
            var _loc_50:*;
            var _loc_51:Array;
            var _loc_52:int;
            var _loc_53:int;
            var _loc_54:int;
            var _loc_55:Boolean;
            var _loc_56:int;
            var _loc_57:int;
            var _loc_58:int;
            var _loc_59:*;
            var _loc_60:Number;
            var _loc_61:Number;
            var _loc_62:Number;
            var _loc_63:Number;
            var _loc_64:*;
            var _loc_65:*;
            var _loc_66:*;
            var _loc_67:*;
            var _loc_68:int;
            var _loc_69:Number;
            var _loc_70:Number;
            if (gameTimer.timeLeft > 0)
            {
                if (_179f == "pickupFind")
                {
                    _loc_1 = 0;
                    _loc_2 = 2140000000;
                    _loc_3 = 0;
                    while (_loc_3 < _17a6.length)
                    {
                        // label
                        if (!_17a6[_loc_3].expired && _17a6[_loc_3].positionPlanet == _17a2[_17be].positionPlanet && _17a6[_loc_3].positionShape == _17a2[_17be].positionShape)
                        {
                            _1772++;
                            _loc_4 = _17a6[_loc_3].x - _17a2[_17be].x;
                            _loc_5 = _17a6[_loc_3].y - _17a2[_17be].y;
                            _loc_6 = _loc_4 * _loc_4 + _loc_5 * _loc_5;
                            if (_loc_6 < _loc_2)
                            {
                                _loc_2 = _loc_6;
                                _loc_1 = _loc_3;
                            }// end if
                        }// end if
                        _loc_3++;
                    }// end while
                    if (_1772 > 0)
                    {
                        _179f = "pickup";
                        _loc_7 = _17a6[_loc_1].positionElement;
                        _loc_8 = _17a2[_17be].positionElement;
                        _loc_9 = _loc_7 - _loc_8;
                        _loc_10 = _loc_8 - _loc_7;
                        while (_loc_9 < 0)
                        {
                            // label
                            _loc_9 = _loc_9 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                        }// end while
                        while (_loc_10 < 0)
                        {
                            // label
                            _loc_10 = _loc_10 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                        }// end while
                        if (_loc_9 > _loc_10)
                        {
                            _1768 = 1;
                        }
                        else
                        {
                            _1768 = 0;
                        }// end else if
                    }
                    else
                    {
                        _179f = "find";
                    }// end if
                }// end else if
                if (_179f == "pickup")
                {
                    if (_1772 > 0)
                    {
                        _17a2[_17be].isWalking = true;
                        if (_1768 == 0)
                        {
                            _17cb(_17be, 3);
                        }
                        else
                        {
                            _17c4(_17be, 3);
                        }// end else if
                    }
                    else
                    {
                        _17a2[_17be].isWalking = false;
                        _179f = "find";
                    }// end else if
                }
                else if (_179f == "find")
                {
                    if (_174c[2] > 0 && !_1793)
                    {
                        _1793 = true;
                        _loc_11 = _17310(_17be, null, null, null, "snipe");
                        if (_loc_11 is Array)
                        {
                            _loc_12 = 0;
                            while (_loc_12 < _loc_11.length)
                            {
                                // label
                                if (_17a2[_loc_11[_loc_12]].team == 0)
                                {
                                    if (_17a2[_loc_11[_loc_12]].health <= 40)
                                    {
                                        _1789 = _loc_11[_loc_12];
                                        _176c = 4;
                                        _loc_13 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                                        _loc_14 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                                        _loc_15 = _17a2[_loc_11[_loc_12]].x + 16 * Math.sin((180 - _17a2[_loc_11[_loc_12]].rotation) * (Math.PI / 180));
                                        _loc_16 = _17a2[_loc_11[_loc_12]].y + 16 * Math.cos((180 - _17a2[_loc_11[_loc_12]].rotation) * (Math.PI / 180));
                                        _loc_17 = -Math.atan2(_loc_15 - _loc_13, _loc_16 - _loc_14);
                                        _loc_18 = _17a2[_17be].rotation * (Math.PI / 180);
                                        _loc_19 = (_loc_18 - _loc_17) * (180 / Math.PI);
                                        if (_loc_19 < 0)
                                        {
                                            _loc_19 = _loc_19 + 360;
                                        }// end if
                                        if (_loc_19 > 360)
                                        {
                                            _loc_19 = _loc_19 - 360;
                                        }// end if
                                        _loc_20 = 0;
                                        if (_loc_19 < 180)
                                        {
                                            _loc_20 = Math.round(_loc_19);
                                            _17a2[_17be].scaleX = -1;
                                        }
                                        else
                                        {
                                            _loc_20 = Math.round(180 - (_loc_19 - 180));
                                            _17a2[_17be].scaleX = 1;
                                        }// end else if
                                        if (_loc_20 <= 0)
                                        {
                                            _loc_20 = 1;
                                        }// end if
                                        _17c9 = _loc_20;
                                    }// end if
                                }// end if
                                _loc_12++;
                            }// end while
                        }// end if
                    }// end if
                    if (_174c[4] > 0 && !_1796 && _1789 > -1 && _17a2[_1789].health > 40 || _1789 == -1)
                    {
                        _1796 = true;
                        _loc_21 = 0;
                        while (_loc_21 < _17a2.length)
                        {
                            // label
                            if (_17a2[_loc_21].team == 0 && _17a2[_loc_21].positionPlanet == _17a2[_17be].positionPlanet && _17a2[_loc_21].positionShape == _17a2[_17be].positionShape)
                            {
                                if (_17a2[_loc_21].health <= 25)
                                {
                                    _176c = 8;
                                    _175f = _loc_21;
                                }// end if
                            }// end if
                            _loc_21++;
                        }// end while
                    }// end if
                    if (_175f == -1 && _1789 == -1)
                    {
                        if (_17a4.length == 0 && _178a <= 10)
                        {
                            _178a++;
                            _17a2[_17be].changeAnim("thinking");
                            _176c = 1;
                            _loc_22 = 3 * _178a;
                            _loc_23 = 0;
                            while (_loc_23 < 72)
                            {
                                // label
                                _loc_17 = _loc_23 / 36 * Math.PI;
                                _17a4.push(new TargetProjectile());
                                _1778.addChild(_17a4[_17a4.length-1]);
                                _17a4[_17a4.length-1].alpha = 0;
                                _loc_24 = _loc_22 * Math.sin(-_loc_17);
                                _loc_25 = _loc_22 * Math.cos(-_loc_17);
                                _loc_18 = _17a2[_17be].rotation * (Math.PI / 180);
                                _loc_19 = (_loc_18 - _loc_17) * (180 / Math.PI);
                                if (_loc_19 < 0)
                                {
                                    _loc_19 = _loc_19 + 360;
                                }// end if
                                if (_loc_19 > 360)
                                {
                                    _loc_19 = _loc_19 - 360;
                                }// end if
                                _loc_20 = 0;
                                if (_loc_19 < 180)
                                {
                                    _loc_20 = Math.round(_loc_19);
                                    _17a4[_17a4.length-1].GFXscale = -1;
                                }
                                else
                                {
                                    _loc_20 = Math.round(180 - (_loc_19 - 180));
                                    _17a4[_17a4.length-1].GFXscale = 1;
                                }// end else if
                                if (_loc_20 <= 0)
                                {
                                    _loc_20 = 1;
                                }// end if
                                _17a4[_17a4.length-1].GFXframe = _loc_20;
                                _loc_26 = _17a10.getPos(_176c, _loc_20);
                                if (_loc_19 < 180)
                                {
                                    _loc_26.x = _loc_26.x * -1;
                                }// end if
                                _17af = new Point(_17a2[_17be].localToGlobal(_loc_26).x - x, _17a2[_17be].localToGlobal(_loc_26).y - y);
                                _17a4[_17a4.length-1].x = _17af.x;
                                _17a4[_17a4.length-1].y = _17af.y;
                                _17a4[_17a4.length-1].momX = _loc_24;
                                _17a4[_17a4.length-1].momY = _loc_25;
                                _17a4[_17a4.length-1].AImomX = _17a4[_17a4.length-1].momX;
                                _17a4[_17a4.length-1].AImomY = _17a4[_17a4.length-1].momY;
                                _17a4[_17a4.length-1].AIposX = _17a4[_17a4.length-1].x;
                                _17a4[_17a4.length-1].AIposY = _17a4[_17a4.length-1].y;
                                _loc_23++;
                            }// end while
                        }
                        else if (_17a4.length > 0)
                        {
                            _1778.graphics.lineStyle(1, 16711680, 1);
                            _loc_27 = 0;
                            _loc_28 = getTimer();
                            _loc_29 = false;
                            while (_loc_27 < 150 && _17a4.length > 0)
                            {
                                // label
                                _17a4[0].doGravity(_plantes);
                                _17a4[0].moveProjectile(_175b, _1795, _177c, _1797);
                                _loc_30 = 0;
                                while (_loc_30 < _1737.length)
                                {
                                    // label
                                    if (_1737[_loc_30 + 1])
                                    {
                                        _loc_31 = new Point(_1737[_loc_30].x, _1737[_loc_30].y);
                                        _loc_32 = new Point(_1737[_loc_30 + 1].x, _1737[_loc_30 + 1].y);
                                        _loc_33 = new Point(_17a4[0].x, _17a4[0].y);
                                        _loc_34 = new Point(_17a4[0].oldX, _17a4[0].oldY);
                                        _loc_35 = lineIntersectLine(_loc_31, _loc_32, _loc_33, _loc_34, true);
                                        if (!_17a4[0].removeMe && _loc_35 && _17a4[0].shieldDelay <= 0)
                                        {
                                            _loc_36 = _loc_35.x;
                                            _loc_37 = _loc_35.y;
                                            _loc_38 = new Point(_17a4[0].momX, _17a4[0].momY);
                                            _loc_39 = new Point(_loc_31.x, _loc_31.y);
                                            _loc_40 = new Point(_loc_32.x, _loc_32.y);
                                            _loc_41 = new Point(_loc_33.x, _loc_33.y);
                                            _loc_42 = new Point(_loc_34.x, _loc_34.y);
                                            _loc_43 = _1792(_loc_39, _loc_40, _loc_41, _loc_42, _loc_38, 1);
                                            _17a4[0].reflected = true;
                                            _17a4[0].shieldDelay = 2;
                                            _17a4[0].x = _loc_36;
                                            _17a4[0].y = _loc_37;
                                            _17a4[0].momX = _loc_43[1].x;
                                            _17a4[0].momY = _loc_43[1].y;
                                        }// end if
                                    }// end if
                                    _loc_30 = _loc_30 + 2;
                                }// end while
                                _loc_29 = _1773(_17a4[0]);
                                if (_loc_29)
                                {
                                    if (_loc_29[0] == "unit")
                                    {
                                        if (_17a2[_loc_29[1]].team == 0)
                                        {
                                            _17ae.push(new AIHit(_17a4[0].GFXframe, _17a4[0].GFXscale, _17a4[0].AImomX, _17a4[0].AImomY, _17a4[0].AIposX, _17a4[0].AIposY, _loc_29[1], _17a4[0].multi));
                                        }// end if
                                    }
                                    else if (_loc_29[0] == "planet")
                                    {
                                        _loc_44 = 2140000000;
                                        _loc_45 = 0;
                                        _loc_46 = 0;
                                        while (_loc_46 < _17a2.length)
                                        {
                                            // label
                                            if (_17a2[_loc_46].team == 0)
                                            {
                                                _loc_48 = _17a4[0].x - _17a2[_loc_46].x;
                                                _loc_49 = _17a4[0].y - _17a2[_loc_46].y;
                                                _loc_50 = _loc_48 * _loc_48 + _loc_49 * _loc_49;
                                                if (_loc_50 < _loc_44)
                                                {
                                                    _loc_44 = _loc_50;
                                                    _loc_45 = _loc_46;
                                                }// end if
                                            }// end if
                                            _loc_46++;
                                        }// end while
                                        _loc_47 = _loc_44;
                                        _17810.push(new AIHitPlanet(_17a4[0].GFXframe, _17a4[0].GFXscale, _17a4[0].AImomX, _17a4[0].AImomY, _17a4[0].AIposX, _17a4[0].AIposY, _loc_47));
                                    }// end else if
                                    _1778.removeChild(_17a4[0]);
                                    _17a4.splice(0, 1);
                                }
                                else if (_17a4[0].distance >= (_17a2[_17be].accuracy - 5) * 6 + 600)
                                {
                                    _1778.removeChild(_17a4[0]);
                                    _17a4.splice(0, 1);
                                }// end else if
                                _loc_27++;
                            }// end while
                        }
                        else
                        {
                            _loc_51 = new Array();
                            if (_17ae.length > 0)
                            {
                                _loc_52 = 0;
                                while (_loc_52 < _17ae.length)
                                {
                                    // label
                                    if (_17a2[_17ae[_loc_52].unitHit].health < 25 * _17ae[_loc_52].multi)
                                    {
                                        _loc_51.push(_loc_52);
                                        _17ae[_loc_52].wepToKill = 1;
                                    }
                                    else if (_174c[1] > 0 && _17a2[_17ae[_loc_52].unitHit].health < 40 * _17ae[_loc_52].multi)
                                    {
                                        _loc_51.push(_loc_52);
                                        _17ae[_loc_52].wepToKill = 2;
                                    }
                                    else if (_174c[8] > 0 && _17a2[_17ae[_loc_52].unitHit].health < 75 * _17ae[_loc_52].multi)
                                    {
                                        _loc_51.push(_loc_52);
                                        _17ae[_loc_52].wepToKill = 7;
                                    }// end else if
                                    _loc_52++;
                                }// end while
                                if (_loc_51.length > 0)
                                {
                                    _1787 = _loc_51[Math.floor(Math.random() * _loc_51.length)];
                                    _179d = 0;
                                    _176c = _17ae[_1787].wepToKill;
                                }
                                else
                                {
                                    _1787 = Math.floor(Math.random() * _17ae.length);
                                    _179d = 0;
                                    _176c = 1;
                                }// end else if
                                _17a2[_17be].changeAnim("aiming" + _176c);
                                _17a2[_17be].scaleX = _17ae[_1787].GFXscale;
                                _179f = "findretreat";
                            }
                            else if (_17810.length > 0)
                            {
                                _loc_2 = 2140000000;
                                _loc_53 = 0;
                                _loc_52 = 0;
                                while (_loc_52 < _17810.length)
                                {
                                    // label
                                    if (_17810[_loc_52].unitDist < _loc_2)
                                    {
                                        _loc_2 = _17810[_loc_52].unitDist;
                                        _loc_53 = _loc_52;
                                    }// end if
                                    _loc_52++;
                                }// end while
                                _179d = 1;
                                _1787 = _loc_53;
                                _176c = 1;
                                _loc_54 = 0;
                                while (_loc_54 < _17810.length)
                                {
                                    // label
                                    _loc_54++;
                                }// end while
                                _179f = "findretreat";
                            }
                            else
                            {
                                _179f = "findchangepos";
                            }// end else if
                        }// end else if
                    }
                    else
                    {
                        _17a2[_17be].changeAnim("aiming" + _176c);
                        _179f = "findretreat";
                    }// end else if
                }
                else if (_179f == "findchangepos")
                {
                    _loc_55 = false;
                    _loc_56 = 0;
                    _179c = -1;
                    _loc_57 = _17a2[_17be].positionElement;
                    while (_179f == "findchangepos" && _loc_56 < _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length / 3 && !_loc_55)
                    {
                        // label
                        _loc_56++;
                        _loc_58 = (Math.floor(Math.random() * 2) * 2)-- * -1;
                        _loc_57 = (_loc_57 + 3 * _loc_56 * _loc_58) % _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                        if (_loc_57 < 0)
                        {
                            _loc_57 = _loc_57 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                        }// end if
                        if (!_17310(_17be, _17a2[_17be].positionPlanet, _17a2[_17be].positionShape, _loc_57, "change"))
                        {
                            _1791++;
                            if (_1791 > 3)
                            {
                                _174c[7] = 1;
                                if (_174c[7] > 0)
                                {
                                    _179f = "teleport";
                                    do
                                    {
                                        // label
                                        _loc_59 = Math.floor(Math.random() * _plantes.length);
                                    }while (_loc_59 == _17a2[_17be].positionPlanet || _plantes[_loc_59].isSun)
                                    _17a2[_17be].healthDisplay.hideHealth();
                                    _17a2[_17be].positionPlanetTeleTo = _loc_59;
                                    _17a2[_17be].positionShapeTeleTo = Math.floor(Math.random() * _plantes[_loc_59].shapeArray.length);
                                    _17a2[_17be].positionElementTeleTo = Math.floor(Math.random() * _plantes[_loc_59].shapeArray[_17a2[_17be].positionShapeTeleTo].length);
                                    _17a2[_17be].positionElementXTeleTo = _plantes[_loc_59].shapeArray[_17a2[_17be].positionShapeTeleTo][_17a2[_17be].positionElementTeleTo].x;
                                    _17a2[_17be].positionElementYTeleTo = _plantes[_loc_59].shapeArray[_17a2[_17be].positionShapeTeleTo][_17a2[_17be].positionElementTeleTo].y;
                                    _17a2[_17be].changeAnim("teleportout");
                                    gameTimer.hideIt();
                                    gameTimer.resetRetreatTimer();
                                    _17210 = "sim";
                                    var _loc_71:* = _174c;
                                    var _loc_72:int;
                                    _loc_71[_loc_72] = _174c[7]--;
                                }// end if
                                continue;
                            }// end if
                            _179c = _loc_57;
                            _loc_55 = true;
                            _loc_7 = _loc_57;
                            _loc_8 = _17a2[_17be].positionElement;
                            _loc_9 = _loc_7 - _loc_8;
                            _loc_10 = _loc_8 - _loc_7;
                            while (_loc_9 < 0)
                            {
                                // label
                                _loc_9 = _loc_9 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            }// end while
                            while (_loc_10 < 0)
                            {
                                // label
                                _loc_10 = _loc_10 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            }// end while
                            if (_loc_9 > _loc_10)
                            {
                                _1768 = 1;
                                continue;
                            }// end if
                            _1768 = 0;
                        }// end if
                    }// end while
                    if (_179c == -1)
                    {
                        _1791++;
                        if (_1791 >= 3)
                        {
                            if (_174c[7] > 0)
                            {
                                do
                                {
                                    // label
                                    _loc_59 = Math.floor(Math.random() * _plantes.length);
                                }while (_loc_59 == _17a2[_17be].positionPlanet || _plantes[_loc_59].isSun)
                                _17a2[_17be].healthDisplay.hideHealth();
                                _17a2[_17be].positionPlanetTeleTo = _loc_59;
                                _17a2[_17be].positionShapeTeleTo = Math.floor(Math.random() * _plantes[_loc_59].shapeArray.length);
                                _17a2[_17be].positionElementTeleTo = Math.floor(Math.random() * _plantes[_loc_59].shapeArray[_17a2[_17be].positionShapeTeleTo].length);
                                _17a2[_17be].positionElementXTeleTo = _plantes[_loc_59].shapeArray[_17a2[_17be].positionShapeTeleTo][_17a2[_17be].positionElementTeleTo].x;
                                _17a2[_17be].positionElementYTeleTo = _plantes[_loc_59].shapeArray[_17a2[_17be].positionShapeTeleTo][_17a2[_17be].positionElementTeleTo].y;
                                _17a2[_17be].changeAnim("teleportout");
                                var _loc_71:* = _174c;
                                var _loc_72:int;
                                _loc_71[_loc_72] = _174c[7]--;
                            }// end if
                        }
                        else
                        {
                            _1791++;
                            _179c = Math.random() * _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            _179f = "changepos";
                        }// end else if
                    }
                    else
                    {
                        _179f = "changepos";
                    }// end else if
                }
                else if (_179f == "changepos")
                {
                    if (_179c != -1 && _179c != _17a2[_17be].positionElement)
                    {
                        _17a2[_17be].isWalking = true;
                        if (_1768 == 0)
                        {
                            _17cb(_17be, 3);
                        }
                        else
                        {
                            _17c4(_17be, 3);
                        }// end else if
                    }
                    else
                    {
                        _179f = "find";
                        _178a = 0;
                    }// end else if
                }
                else if (_179f == "shootSnipe")
                {
                    _loc_60 = _17a2[_17be].x + 16 * Math.sin((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                    _loc_61 = _17a2[_17be].y + 16 * Math.cos((180 - _17a2[_17be].rotation) * (Math.PI / 180));
                    _loc_62 = _17a2[_1789].x + 16 * Math.sin((180 - _17a2[_1789].rotation) * (Math.PI / 180));
                    _loc_63 = _17a2[_1789].y + 16 * Math.cos((180 - _17a2[_1789].rotation) * (Math.PI / 180));
                    _loc_64 = (_loc_62 - _loc_60) / 10;
                    _loc_65 = (_loc_63 - _loc_61) / 10;
                    _loc_66 = Math.sqrt(_loc_64 * _loc_64 + _loc_65 * _loc_65);
                    _loc_67 = 10 / _loc_66;
                    _loc_64 = _loc_64 * _loc_67;
                    _loc_65 = _loc_65 * _loc_67;
                    _17910(_loc_60, _loc_61, _loc_64, _loc_65, 0, "bullet", null);
                    _1778.graphics.lineStyle(1, 16777215, 1);
                    _178d = 2;
                    if (MovieClip(root).sfx)
                    {
                        MovieClip(root).soundmanager.sound_sniper.gotoAndPlay(2);
                    }// end if
                    do
                    {
                        // label
                        _1778.graphics.moveTo(_projectileArr[_projectileArr.length-1].x, _projectileArr[_projectileArr.length-1].y);
                        _projectileArr[_projectileArr.length-1].doGravity(_plantes);
                        _projectileArr[_projectileArr.length-1].moveProjectile(_175b, _1795, _177c, _1797);
                        _1778.graphics.lineTo(_projectileArr[_projectileArr.length-1].x, _projectileArr[_projectileArr.length-1].y);
                        _loc_30 = 0;
                        while (_loc_30 < _1737.length)
                        {
                            // label
                            if (_1737[_loc_30 + 1])
                            {
                                _loc_31 = new Point(_1737[_loc_30].x, _1737[_loc_30].y);
                                _loc_32 = new Point(_1737[_loc_30 + 1].x, _1737[_loc_30 + 1].y);
                                _loc_33 = new Point(_projectileArr[_projectileArr.length-1].x, _projectileArr[_projectileArr.length-1].y);
                                _loc_34 = new Point(_projectileArr[_projectileArr.length-1].oldX, _projectileArr[_projectileArr.length-1].oldY);
                                _loc_35 = lineIntersectLine(_loc_31, _loc_32, _loc_33, _loc_34, true);
                                if (!_projectileArr[_projectileArr.length-1].removeMe && _loc_35 && _projectileArr[_projectileArr.length-1].shieldDelay <= 0)
                                {
                                    _loc_36 = _loc_35.x;
                                    _loc_37 = _loc_35.y;
                                    _loc_38 = new Point(_projectileArr[_projectileArr.length-1].momX, _projectileArr[_projectileArr.length-1].momY);
                                    _loc_39 = new Point(_loc_31.x, _loc_31.y);
                                    _loc_40 = new Point(_loc_32.x, _loc_32.y);
                                    _loc_41 = new Point(_loc_33.x, _loc_33.y);
                                    _loc_42 = new Point(_loc_34.x, _loc_34.y);
                                    _loc_43 = _1792(_loc_39, _loc_40, _loc_41, _loc_42, _loc_38, 1);
                                    _projectileArr[_projectileArr.length-1].reflected = true;
                                    _projectileArr[_projectileArr.length-1].shieldDelay = 2;
                                    _projectileArr[_projectileArr.length-1].x = _loc_36;
                                    _projectileArr[_projectileArr.length-1].y = _loc_37;
                                    _projectileArr[_projectileArr.length-1].momX = _loc_43[1].x;
                                    _projectileArr[_projectileArr.length-1].momY = _loc_43[1].y;
                                }// end if
                            }// end if
                            _loc_30 = _loc_30 + 2;
                        }// end while
                        _loc_29 = _1773(_projectileArr[_projectileArr.length-1]);
                        if (_loc_29)
                        {
                            _projectileArr[_projectileArr.length-1].removeMe = true;
                            if (_loc_29[0] == "unit")
                            {
                                _17a2[_loc_29[1]].changeAnim("falldown");
                                if (_17a2[_loc_29[1]].killReg == -1 && _17a2[_loc_29[1]].health <= _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi)
                                {
                                    _17a2[_loc_29[1]].killReg = 4;
                                }// end if
                                _17a2[_loc_29[1]].damageTaken = _17a2[_loc_29[1]].damageTaken + _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi;
                                if (_17a2[_loc_29[1]].team != 0 && myTeamsTurn)
                                {
                                    _1794 = _1794 + _projectileArr[_1726].maxDamage * _projectileArr[_1726].multi;
                                }// end if
                            }// end if
                        }// end if
                    }while (!_projectileArr[_projectileArr.length-1].removeMe)
                    var _loc_71:* = _174c;
                    var _loc_72:int;
                    _loc_71[_loc_72] = _174c[2]--;
                    gameTimer.hideIt();
                    gameTimer.resetRetreatTimer();
                    _17210 = "sim";
                    _1735.hideMe();
                    _17b4();
                    _179f = "retreat";
                }
                else if (_179f == "shoot")
                {
                    _loc_68 = (105 - _17a2[_17be].accuracy) / 30;
                    _loc_69 = _loc_68 * Math.random() - _loc_68 / 2;
                    _loc_70 = _loc_68 * Math.random() - _loc_68 / 2;
                    if (_179d == 0)
                    {
                        _17910(_17ae[_1787].posX, _17ae[_1787].posY, _17ae[_1787].momX + _loc_69, _17ae[_1787].momY + _loc_70, 0, "bullet", null);
                    }
                    else if (_179d == 1)
                    {
                        _17910(_17810[_1787].posX, _17810[_1787].posY, _17810[_1787].momX + _loc_69, _17810[_1787].momY + _loc_70, 0, "bullet", null);
                    }// end else if
                    gameTimer.hideIt();
                    gameTimer.resetRetreatTimer();
                    _17210 = "sim";
                    _1735.hideMe();
                    _17b4();
                    _179f = "retreat";
                    if (_176c == 2)
                    {
                        var _loc_71:* = _174c;
                        var _loc_72:int;
                        _loc_71[_loc_72] = _174c[1]--;
                    }
                    else if (_176c == 6)
                    {
                        var _loc_71:* = _174c;
                        var _loc_72:int;
                        _loc_71[_loc_72] = _174c[3]--;
                    }
                    else if (_176c == 5)
                    {
                        var _loc_71:* = _174c;
                        var _loc_72:int;
                        _loc_71[_loc_72] = _174c[6]--;
                    }
                    else if (_176c == 7)
                    {
                        var _loc_71:* = _174c;
                        var _loc_72:int;
                        _loc_71[_loc_72] = _174c[8]--;
                    }// end else if
                    if (_176c == 1 || _176c == 2)
                    {
                        if (MovieClip(root).sfx)
                        {
                            MovieClip(root).soundmanager.sound_rocketshoot.gotoAndPlay(2);
                        }// end if
                    }// end if
                }
                else if (_179f == "findretreat")
                {
                    if (_1789 > -1)
                    {
                        _17a2[_17be].graphic.gotoAndStop(_17c9);
                    }
                    else if (_175f > -1)
                    {
                    }
                    else if (_179d == 0)
                    {
                        _17a2[_17be].scaleX = _17ae[_1787].GFXscale;
                        _17a2[_17be].graphic.gotoAndStop(_17ae[_1787].GFXframe);
                    }
                    else if (_179d == 1)
                    {
                        _17a2[_17be].scaleX = _17810[_1787].GFXscale;
                        _17a2[_17be].graphic.gotoAndStop(_17810[_1787].GFXframe);
                    }// end else if
                    _loc_55 = false;
                    _loc_56 = 0;
                    _179c = -1;
                    _loc_57 = _17a2[_17be].positionElement;
                    if (!_17310(_17be, null, null, null, "retreat"))
                    {
                        while (_loc_56 < _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length / 3 && !_loc_55)
                        {
                            // label
                            _loc_56++;
                            _loc_58 = (Math.floor(Math.random() * 2) * 2)-- * -1;
                            _loc_57 = (_loc_57 + 3 * _loc_56 * _loc_58) % _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            if (_loc_57 < 0)
                            {
                                _loc_57 = _loc_57 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            }// end if
                            if (_17310(_17be, _17a2[_17be].positionPlanet, _17a2[_17be].positionShape, _loc_57, "retreat"))
                            {
                                _179c = _loc_57;
                                _loc_55 = true;
                                _loc_7 = _loc_57;
                                _loc_8 = _17a2[_17be].positionElement;
                                _loc_9 = _loc_7 - _loc_8;
                                _loc_10 = _loc_8 - _loc_7;
                                while (_loc_9 < 0)
                                {
                                    // label
                                    _loc_9 = _loc_9 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                                }// end while
                                while (_loc_10 < 0)
                                {
                                    // label
                                    _loc_10 = _loc_10 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                                }// end while
                                if (_loc_9 > _loc_10)
                                {
                                    _1768 = 1;
                                    continue;
                                }// end if
                                _1768 = 0;
                            }// end if
                        }// end while
                        if (_1789 > -1)
                        {
                            _179f = "shootSnipe";
                        }
                        else if (_175f > -1)
                        {
                            _174b = _17a2[_175f].positionElement;
                            _loc_55 = true;
                            _loc_7 = _174b;
                            _loc_8 = _17a2[_17be].positionElement;
                            _loc_9 = _loc_7 - _loc_8;
                            _loc_10 = _loc_8 - _loc_7;
                            while (_loc_9 < 0)
                            {
                                // label
                                _loc_9 = _loc_9 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            }// end while
                            while (_loc_10 < 0)
                            {
                                // label
                                _loc_10 = _loc_10 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                            }// end while
                            if (_loc_9 > _loc_10)
                            {
                                _1768 = 1;
                            }
                            else
                            {
                                _1768 = 0;
                            }// end else if
                            _179f = "walkMine";
                        }
                        else
                        {
                            _179f = "shoot";
                        }// end else if
                    }
                    else if (_1789 > -1)
                    {
                        _179f = "shootSnipe";
                    }
                    else if (_175f > -1)
                    {
                        _174b = _17a2[_175f].positionElement;
                        _loc_55 = true;
                        _179c = 0;
                        _loc_7 = _174b;
                        _loc_8 = _17a2[_17be].positionElement;
                        _loc_9 = _loc_7 - _loc_8;
                        _loc_10 = _loc_8 - _loc_7;
                        while (_loc_9 < 0)
                        {
                            // label
                            _loc_9 = _loc_9 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                        }// end while
                        while (_loc_10 < 0)
                        {
                            // label
                            _loc_10 = _loc_10 + _plantes[_17a2[_17be].positionPlanet].shapeArray[_17a2[_17be].positionShape].length;
                        }// end while
                        if (_loc_9 > _loc_10)
                        {
                            _1768 = 1;
                        }
                        else
                        {
                            _1768 = 0;
                        }// end else if
                        _179f = "walkMine";
                    }
                    else
                    {
                        _179f = "shoot";
                    }// end else if
                }
                else if (_179f == "retreat")
                {
                    if (MovieClip(root).levelSetup.levelID < 5)
                    {
                        _179c = -1;
                    }// end if
                    if (_179c != -1 && _179c != _17a2[_17be].positionElement)
                    {
                        _17a2[_17be].isWalking = true;
                        if (_1768 == 0)
                        {
                            _17cb(_17be, 3);
                        }
                        else
                        {
                            _17c4(_17be, 3);
                        }// end else if
                    }
                    else if (_179c == -1 && _176c == 8)
                    {
                        _17a2[_17be].isWalking = true;
                        if (_1768 == 0)
                        {
                            _17cb(_17be, 3);
                        }
                        else
                        {
                            _17c4(_17be, 3);
                        }// end else if
                    }
                    else
                    {
                        _17a2[_17be].isWalking = false;
                    }// end else if
                }
                else if (_179f == "walkMine")
                {
                    if (_174b != -1 && _174b != _17a2[_17be].positionElement)
                    {
                        _17a2[_17be].isWalking = true;
                        if (_1768 == 0)
                        {
                            _17cb(_17be, 3);
                        }
                        else
                        {
                            _17c4(_17be, 3);
                        }// end else if
                    }
                    else
                    {
                        _17a2[_17be].isWalking = false;
                        _17a2[_17be].changeAnim("aiming8");
                        _179f = "placeMine";
                    }// end else if
                }
                else if (_179f == "placeMine")
                {
                    _mines.push(new Mine());
                    _1764.addChild(_mines[_mines.length-1]);
                    _mines[_mines.length-1].x = _17a2[_17be].x;
                    _mines[_mines.length-1].y = _17a2[_17be].y;
                    _mines[_mines.length-1].positionPlanet = _17a2[_17be].positionPlanet;
                    _mines[_mines.length-1].positionShape = _17a2[_17be].positionShape;
                    _mines[_mines.length-1].positionElement = _17a2[_17be].positionElement;
                    _mines[_mines.length-1].positionElementX = _17a2[_17be].positionElementX;
                    _mines[_mines.length-1].positionElementY = _17a2[_17be].positionElementY;
                    _mines[_mines.length-1].rotation = _17a2[_17be].rotation;
                    var _loc_71:* = _174c;
                    var _loc_72:int;
                    _loc_71[_loc_72] = _174c[4]--;
                    gameTimer.hideIt();
                    gameTimer.resetRetreatTimer();
                    _17210 = "sim";
                    _1735.hideMe();
                    _17b4();
                    _179f = "retreat";
                }// end else if
            }// end else if
            return;
        }// end function

    }
}
