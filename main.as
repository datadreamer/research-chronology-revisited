
// RESEARCH CHRONOLOGY REVISITED
// by Aaron Siegel
// August 2006

//----------------------------------------------------------------------
//Symbol 25 MovieClip [loading] Frame 30
//----------------------------------------------------------------------
stop();
﻿
//----------------------------------------------------------------------
//Frame 1
//----------------------------------------------------------------------
function alphaOrder(a, b) {
    if (a[0] < b[0]) {
        return(-1);
    }
    if (a[0] > b[0]) {
        return(1);
    }
    return(0);
}
function numOrder(a, b) {
    if (a[1] < b[1]) {
        return(1);
    }
    if (a[1] > b[1]) {
        return(-1);
    }
    if (a[0] < b[0]) {
        return(-1);
    }
    if (a[0] > b[0]) {
        return(1);
    }
    return(0);
}
function parseXML(xml) {
    postlist = [];
    taglist = new Object();
    i = 0;
    while (i < xml.firstChild.childNodes.length) {
        post = new Object();
        date = xml.firstChild.childNodes[i].childNodes[0].firstChild.nodeValue.split("-");
        time = xml.firstChild.childNodes[i].childNodes[1].firstChild.nodeValue.split(":");
        datetime = new Date(date[0], date[1], date[2], time[0], time[1], time[2]);
        datetime.setHours(datetime.getHours() + timeoffset);
        if (datetime.getMinutes() < 10) {
            newminutes = "0" + datetime.getMinutes();
        } else {
            newminutes = datetime.getMinutes();
        }
        if (datetime.getSeconds() < 10) {
            newseconds = "0" + datetime.getSeconds();
        } else {
            newseconds = datetime.getSeconds();
        }
        if (datetime.getMonth() < 10) {
            newmonth = "0" + datetime.getMonth();
        } else {
            newmonth = datetime.getMonth();
        }
        if (datetime.getDate() < 10) {
            newdate = "0" + datetime.getDate();
        } else {
            newdate = datetime.getDate();
        }
        post._date = (((datetime.getFullYear() + "-") + newmonth) + "-") + newdate;
        post._time = (((datetime.getHours() + ":") + newminutes) + ":") + newseconds;
        trace((post._date + " ") + post._time);
        post._desc = xml.firstChild.childNodes[i].childNodes[2].firstChild.nodeValue;
        post._url = xml.firstChild.childNodes[i].childNodes[3].firstChild.nodeValue;
        post._tags = xml.firstChild.childNodes[i].childNodes[4].firstChild.nodeValue.split(" ");
        n = 0;
        while (n < post._tags.length) {
            if (taglist[post._tags[n]] == undefined) {
                taglist[post._tags[n]] = 1;
            } else {
                taglist[post._tags[n]] = taglist[post._tags[n]] + 1;
            }
            n++;
        }
        postlist.push(post);
        i++;
    }
    tag_array = new Array();
    for (item in taglist) {
        if (taglist[item] > 1) {
            tag_array.push([item, taglist[item]]);
        }
    }
    tag_array.sort(alphaOrder);
    return(tag_array);
}
function drawMasks() {
    _root.attachMovie("mask", "topmask", _root.getNextHighestDepth(), {_x:-10, _y:0, _width:Stage.width + 20});
    _root.attachMovie("mask2", "bottommask", _root.getNextHighestDepth(), {_x:-10, _y:Stage.height, _width:Stage.width + 20});
}
function drawPosts(postlist) {
    _root.createEmptyMovieClip("dotbox", _root.getNextHighestDepth());
    dotbox.createEmptyMovieClip("dates", dotbox.getNextHighestDepth());
    dotbox.createEmptyMovieClip("lines", dotbox.getNextHighestDepth());
    dotbox.createEmptyMovieClip("curves", dotbox.getNextHighestDepth());
    dotbox.createEmptyMovieClip("dots", dotbox.getNextHighestDepth());
    current_date = new Date();
    current_date.setHours(0);
    current_date.setMinutes(0);
    current_date.setSeconds(0);
    current_date.setMilliseconds(0);
    current_timezone = current_date.getTimezoneOffset();
    oldest = 0;
    dot_array = new Array();
    i = 0;
    while (i < postlist.length) {
        date = postlist[i]._date.split("-");
        time = postlist[i]._time.split(":");
        post_date = new Date(date[0], date[1] - 1, date[2], 0, 0, 0, 0);
        if (current_timezone < post_date.getTimezoneOffset()) {
            date_diff = int((current_date - post_date) / 86400000) + 1;
        } else if (current_timezone > post_date.getTimezoneOffset()) {
            date_diff = int((current_date - post_date) / 86400000) - 1;
        } else {
            date_diff = int((current_date - post_date) / 86400000);
        }
        fullmins = int((time[1] / 60) * 100);
        if (fullmins < 10) {
            fullmins = "0" + String(fullmins);
        }
        fulltime = String(time[0]) + String(fullmins);
        xpos = int(int(fulltime) / 5);
        ypos = date_diff * 10;
        if (date_diff > oldest) {
            oldest = date_diff;
        }
        depth = dotbox.dots.getNextHighestDepth();
        dotbox.dots.attachMovie("dot", "dot" + depth, depth, {_x:xpos, _y:ypos, date:postlist[i]._date, time:postlist[i]._time, desc:postlist[i]._desc, url:postlist[i]._url, tags:postlist[i]._tags});
        dotbox.dots["dot" + depth].dot();
        dot_array.push(dotbox.dots["dot" + depth]);
        i++;
    }
    dotbox.lineStyle(0, 0, 100);
    dotbox.moveTo(0, 0);
    dotbox.lineTo(480, 0);
    dotbox.lineTo(480, oldest * 10);
    dotbox.lineTo(0, oldest * 10);
    dotbox.lineTo(0, 0);
    dotbox.lineStyle(1, 2236962, 50);
    line_date = current_date;
    depth = dotbox.dates.getNextHighestDepth();
    dotbox.dates.attachMovie("day", depth, depth, {_x:480, _y:-5});
    dotbox.dates[depth].dayfield.text = line_date.getDate();
    i = 0;
    while (i < oldest) {
        line_date.setDate(line_date.getDate() - 1);
        depth = dotbox.dates.getNextHighestDepth();
        dotbox.dates.attachMovie("day", depth, depth, {_x:480, _y:(i * 10) + 5});
        dotbox.dates[depth].dayfield.text = line_date.getDate();
        if (line_date.getDate() == 1) {
            dotbox.dates.attachMovie("month", "month_" + line_date.getMonth(), dotbox.dates.getNextHighestDepth(), {_x:2, _y:(i * 10) + 5, month:months[line_date.getMonth()]});
            dotbox.lineStyle(1, 1118481, 70);
            dotbox.moveTo(0, (i * 10) + 10);
            dotbox.lineTo(480, (i * 10) + 10);
            dotbox.lineStyle(1, 2236962, 50);
        } else {
            dotbox.moveTo(0, (i * 10) + 10);
            dotbox.lineTo(480, (i * 10) + 10);
        }
        i++;
    }
    dotbox._x = (Stage.width / 2) - (dotbox._width / 2);
    dotbox._y = 20;
    _root.createEmptyMovieClip("dotbar", _root.getNextHighestDepth());
    dotbar._x = dotbox._x + dotbox._width;
    dotbar._y = 20;
    dotbar.box = "dotbox";
    dotbar.scrollbar();
    return(dot_array);
}
function drawTags(tag_array) {
    _root.createEmptyMovieClip("tagbox", _root.getNextHighestDepth());
    i = 0;
    while (i < tag_array.length) {
        tag = tag_array[i][0].toUpperCase();
        tagnum = tag_array[i][1];
        tagbox.attachMovie("tagselect", "tag_" + tag, tagbox.getNextHighestDepth(), {_x:0, _y:i * 10, tagname:tag, tagnum:tagnum});
        tagbox["tag_" + tag].tagswitch();
        i++;
    }
    tagbox._x = (dotbox._x + dotbox._width) + 20;
    tagbox._y = 20;
    _root.createEmptyMovieClip("tagbar", _root.getNextHighestDepth());
    tagbar._x = tagbox._x + tagbox._width;
    tagbar._y = 20;
    tagbar.box = "tagbox";
    tagbar.scrollbar();
}
function drawLines(tag_array, dot_array) {
    tag_array.sort(numOrder);
    toptag = tag_array[0][1];
    tag_array.sort(alphaOrder);
    i = 0;
    while (i < tag_array.length) {
        tag = tag_array[i][0];
        bigtag = tag.toUpperCase();
        opacity = (tag_array[i][1] / toptag) * 100;
        dotbox.lines.createEmptyMovieClip("line_" + bigtag, dotbox.lines.getNextHighestDepth());
        dotbox.lines["line_" + bigtag].tag = bigtag;
        dotbox.lines["line_" + bigtag].tagnum = tag_array[i][1];
        dotbox.lines["line_" + bigtag].opacity = opacity;
        dotbox.lines["line_" + bigtag].tint = new Color(dotbox.lines["line_" + bigtag]);
        dotbox.lines["line_" + bigtag].tintalpha = i * (765 / tag_array.length);
        dotbox.lines["line_" + bigtag].tintnum = tag_array[i][1] * (255 / toptag);
        dotbox.lines["line_" + bigtag].lineStyle(4, 16777215, 100);
        dotbox.lines["line_" + bigtag].line();
        dotbox.lines["line_" + bigtag]._visible = false;
        dotbox.curves.createEmptyMovieClip("curve_" + bigtag, dotbox.curves.getNextHighestDepth(), {tag:bigtag, tagnum:tag_array[i][1]});
        dotbox.curves["curve_" + bigtag].tag = bigtag;
        dotbox.curves["curve_" + bigtag].tagnum = tag_array[i][1];
        dotbox.curves["curve_" + bigtag].opacity = opacity;
        dotbox.curves["curve_" + bigtag].tint = new Color(dotbox.curves["curve_" + bigtag]);
        dotbox.curves["curve_" + bigtag].tintalpha = i * (765 / tag_array.length);
        dotbox.curves["curve_" + bigtag].tintnum = tag_array[i][1] * (255 / toptag);
        dotbox.curves["curve_" + bigtag].lineStyle(4, 16777215, 100);
        dotbox.curves["curve_" + bigtag].line();
        dotbox.curves["curve_" + bigtag]._visible = false;
        firstpoint = true;
        n = 0;
        while (n < dot_array.length) {
            t = 0;
            while (t < dot_array[n].tags.length) {
                if (tag == dot_array[n].tags[t]) {
                    if (firstpoint) {
                        dotbox.lines["line_" + bigtag].moveTo(dot_array[n]._x, dot_array[n]._y);
                        dotbox.curves["curve_" + bigtag].moveTo(dot_array[n]._x, dot_array[n]._y);
                        lastx = dot_array[n]._x;
                        lasty = dot_array[n]._y;
                        firstpoint = false;
                    } else {
                        dotbox.lines["line_" + bigtag].lineTo(dot_array[n]._x, dot_array[n]._y);
                        midx = ((dot_array[n]._x - lastx) / 2) + lastx;
                        midy = ((dot_array[n]._y - lasty) / 2) + lasty;
                        diffy1 = ((midy - lasty) / 2) + lasty;
                        diffy2 = ((dot_array[n]._y - midy) / 2) + midy;
                        dotbox.curves["curve_" + bigtag].curveTo(lastx, diffy1, midx, midy);
                        dotbox.curves["curve_" + bigtag].curveTo(dot_array[n]._x, diffy2, dot_array[n]._x, dot_array[n]._y);
                        lastx = dot_array[n]._x;
                        lasty = dot_array[n]._y;
                    }
                }
                t++;
            }
            n++;
        }
        i++;
    }
}
function drawInfo() {
    _root.attachMovie("infobox", "infobox", _root.getNextHighestDepth(), {_x:int(dotbox._x - 170), _y:20});
    infobox.userfield.text = infobox.userfield.text + currentuser;
    _root.attachMovie("controls", "controls", _root.getNextHighestDepth(), {_x:int(dotbox._x - 170), _y:(infobox._y + infobox._height) + 20});
    controls.controls();
}
function getPosts(user, pass) {
    if (user == "") {
        url = "http://www.datadreamer.com/cgi-bin/research2/engine.py";
    } else {
        url = (("http://www.datadreamer.com/cgi-bin/research2/engine.py?user=" + user) + "&pass=") + pass;
    }
    currentuser = user;
    post_xml = new XML();
    post_xml.ignoreWhite = true;
    post_xml.load(url);
    post_xml.onLoad = function (success) {
        (tag_array = parseXML(post_xml));
        dot_array = drawPosts(postlist);
        drawTags(tag_array);
        drawLines(tag_array, dot_array);
        drawInfo();
        drawMasks();
        loading.removeMovieClip();
        loadingmode = false;
        vizmode = true;
        _root.attachMovie("linetext", "linetext", _root.getNextHighestDepth());
        linetext.follow();
    };
}
stageListener = new Object();
stageListener.onResize = function () {
    if (loginmode) {
        login._x = int(Stage.width / 2);
        login._y = int(Stage.height / 2);
    } else if (loadingmode) {
        loading._x = int(Stage.width / 2);
        loading._y = int(Stage.height / 2);
    } else {
        topmask._width = Stage.width + 10;
        bottommask._width = Stage.width + 10;
        bottommask._y = Stage.height;
        dotbox._x = int((Stage.width / 2) - (dotbox._width / 2));
        dotbar._x = dotbox._x + dotbox._width;
        dotbar.redo();
        tagbox._x = (dotbox._x + dotbox._width) + 20;
        tagbar._x = tagbox._x + tagbox._width;
        tagbar.redo();
        infobox._x = (dotbox._x - infobox._width) - 20;
        controls._x = infobox._x;
    }
};
mouseListener = new Object();
mouseListener.onMouseWheel = function (delta) {
    if ((_root._xmouse > _root.dotbox._x) && (_root._xmouse < (_root.dotbox._x + _root.dotbox._width))) {
        if ((_root.dotbox._y <= 20) && (_root.dotbox._y >= ((Stage.height - _root.dotbox._height) - 20))) {
            _root.dotbox._y = _root.dotbox._y + delta;
            if (_root.dotbar.bar._y < (_root.dotbar._height - _root.dotbar.bar._height)) {
                _root.dotbar.bar._y = _root.dotbar.bar._y - (delta * _root.dotbar.barperc);
            } else {
                _root.dotbar.bar._y = (_root.dotbar._height - _root.dotbar.bar._height) - 1;
            }
        } else if (_root.dotbox._y > 20) {
            _root.dotbox._y = 20;
            _root.dotbar.bar._y = 0;
        } else if (_root.dotbox._y < ((Stage.height - _root.dotbox._height) - 20)) {
            _root.dotbox._y = (Stage.height - _root.dotbox._height) - 20;
        }
    } else if ((_root._xmouse > _root.tagbox._x) && (_root._xmouse < (_root.tagbox._x + _root.tagbox._width))) {
        if ((_root.tagbox._y <= 20) && (_root.tagbox._y >= ((Stage.height - _root.tagbox._height) - 20))) {
            _root.tagbox._y = _root.tagbox._y + delta;
            if (_root.tagbar.bar._y < (_root.tagbar._height - _root.tagbar.bar._height)) {
                _root.tagbar.bar._y = _root.tagbar.bar._y - (delta * _root.tagbar.barperc);
            } else {
                _root.tagbar.bar._y = (_root.tagbar._height - _root.tagbar.bar._height) - 1;
            }
        } else if (_root.tagbox._y > 20) {
            _root.tagbox._y = 20;
            _root.tagbar.bar._y = 0;
        } else if (_root.tagbox._y < ((Stage.height - _root.tagbox._height) - 20)) {
            _root.tagbox._y = (Stage.height - _root.tagbox._height) - 20;
        }
    }
};
keyListener = new Object();
keyListener.onKeyDown = function () {
    if (loginmode) {
        if (Key.isDown(13)) {
            login.fadeout = true;
        }
    }
};
Color.prototype.spectrum = function (loc) {
    RGB = {ra:0, rb:0, ga:0, gb:0, ba:0, bb:0};
    if (loc < 255) {
        RGB.ra = 255 - loc;
        RGB.ga = loc;
    } else if ((loc >= 255) && (loc < 510)) {
        RGB.ga = 255 - (loc - 255);
        RGB.ba = loc - 255;
    } else if ((loc >= 510) && (loc < 765)) {
        RGB.ba = 255 - (loc - 510);
        RGB.ra = loc - 510;
    }
    this.setTransform(RGB);
};
Color.prototype.analogous = function (loc) {
    RGB = {ra:0, rb:0, ga:0, gb:0, ba:0, bb:0};
    RGB.ra = 255;
    RGB.ga = 255 - loc;
    this.setTransform(RGB);
};
MovieClip.prototype.login = function () {
    this.fadeout = false;
    this.submit.onPress = function () {
        this._parent.fadeout = true;
    };
    this.onEnterFrame = function () {
        if (this.fadeout) {
            if (this._alpha > 0) {
                this._alpha = this._alpha - 5;
            } else {
                this.fadeout = false;
                getPosts(this.username.text, this.password.text);
                loginmode = false;
                loadingmode = true;
                this.removeMovieClip();
                _root.attachMovie("loading", "loading", _root.getNextHighestDepth(), {_x:Stage.width / 2, _y:Stage.height / 2});
            }
        }
    };
};
MovieClip.prototype.dot = function () {
    this.tagstring = this.tags.join(newline).toUpperCase();
    this.depth = this.getDepth();
    this.below = "dot" + String(this.depth + 1);
    this.above = "dot" + String(this.depth - 1);
    this.timer = 0;
    this.onRollOver = function () {
        _root.infobox.date = this.date;
        _root.infobox.time = this.time;
        _root.infobox.desc = this.desc;
        _root.infobox.url = this.url;
        _root.infobox.tags = this.tagstring;
    };
    this.onRollOut = function () {
        _root.infobox.date = "";
        _root.infobox.time = "";
        _root.infobox.desc = "";
        _root.infobox.url = "";
        _root.infobox.tags = "";
    };
    this.onRelease = function () {
        getURL (this.url, "new");
    };
    this.onEnterFrame = function () {
        if (this.timer < 100) {
            this.leftdiff = this._x - this._parent[this.below]._x;
            if ((this.leftdiff < this._width) && (this.date == this._parent[this.below].date)) {
                if (this._x < (_root.dotbox._width - (this._width / 2))) {
                    this._x = this._x + 1;
                }
            }
            this.rightdiff = this._parent[this.above]._x - this._x;
            if ((this.rightdiff < this._width) && (this.date == this._parent[this.above].date)) {
                if (this._x > (this._width / 2)) {
                    this._x = this._x - 1;
                }
            }
            this.timer = this.timer + 1;
        } else {
            stop();
        }
    };
};
MovieClip.prototype.tagswitch = function () {
    this.hilight = false;
    this.lineon = false;
    this.colorbox._alpha = 0;
    this.boxcolor = new Color(this.colorbox);
    this.testbutton.onRollOver = function () {
        this._alpha = 10;
    };
    this.testbutton.onRollOut = function () {
        if (!this._parent.hilight) {
            this._alpha = 0;
        }
    };
    this.testbutton.onRelease = function () {
        if (this._parent.lineon) {
            this._parent.lineon = false;
            this._parent.hilight = !this._parent.hilight;
            if (curvemode) {
                _root.dotbox.curves["curve_" + this._parent.tagname].power();
            } else {
                _root.dotbox.lines["line_" + this._parent.tagname].power();
            }
            this._parent.colorbox._alpha = 0;
        } else {
            this._parent.lineon = true;
            this._parent.hilight = !this._parent.hilight;
            if (curvemode) {
                _root.dotbox.curves["curve_" + this._parent.tagname].power();
            } else {
                _root.dotbox.lines["line_" + this._parent.tagname].power();
            }
            this._parent.colorMode();
        }
    };
    this.colorMode = function () {
        if (this.lineon) {
            if (colormode == 0) {
                this.opacity = _root.dotbox.lines["line_" + this.tagname].opacity;
                this.boxcolor.setRGB(16777215);
                this.colorbox._alpha = this.opacity;
            } else if (colormode == 1) {
                this.alphatint = _root.dotbox.lines["line_" + this.tagname].tintalpha;
                this.boxcolor.spectrum(this.alphatint);
                this.colorbox._alpha = 100;
            } else if (colormode == 2) {
                this.numtint = _root.dotbox.lines["line_" + this.tagname].tintnum;
                this.opacity = _root.dotbox.lines["line_" + this.tagname].opacity;
                this.boxcolor.analogous(this.numtint);
                this.colorbox._alpha = this.opacity;
            }
        }
    };
};
MovieClip.prototype.line = function () {
    this.viewable = false;
    this.power = function () {
        if (this.viewable) {
            this._visible = false;
            this.viewable = false;
        } else {
            this._visible = true;
            if (colormode == 0) {
                this.tint.setRGB(16777215);
                this._alpha = int(this.opacity);
            } else if (colormode == 1) {
                this.tint.spectrum(this.tintalpha);
                this._alpha = 70;
            } else if (colormode == 2) {
                this.tint.analogous(this.tintnum);
                this._alpha = int(this.opacity);
            }
            this.viewable = true;
        }
    };
    this.colorMode = function () {
        if (this.viewable) {
            this.viewable = false;
            this.power();
        }
    };
    this.onRollOver = function () {
        _root.linetext.field.text = this.tag;
    };
    this.onRollOut = function () {
        _root.linetext.field.text = "";
    };
};
MovieClip.prototype.scrollbar = function () {
    this.lineStyle(1, 0, 0);
    this.beginFill(2236962);
    this.moveTo(0, 0);
    this.lineTo(10, 0);
    this.lineTo(10, Stage.height - 40);
    this.lineTo(0, Stage.height - 40);
    this.lineTo(0, 0);
    this.endFill();
    this.barperc = this._height / _root[this.box]._height;
    this.barheight = this._height * this.barperc;
    this.down = false;
    this.createEmptyMovieClip("bar", 1);
    this.bar.lineStyle(1, 0, 0);
    this.bar.beginFill(4473924);
    this.bar.moveTo(0, 0);
    this.bar.lineTo(10, 0);
    this.bar.lineTo(10, this.barheight);
    this.bar.lineTo(0, this.barheight);
    this.bar.lineTo(0, 0);
    this.bar.endFill();
    this.bar.tint = new Color(this.bar);
    this.redo = function () {
        this.clear();
        this.beginFill(2236962);
        this.moveTo(0, 0);
        this.lineTo(10, 0);
        this.lineTo(10, Stage.height - 40);
        this.lineTo(0, Stage.height - 40);
        this.lineTo(0, 0);
        this.endFill();
        this.barperc = this._height / _root[this.box]._height;
        this.bar._height = this._height * this.barperc;
    };
    this.bar.onRollOver = function () {
        this.tint.setRGB(6710886);
    };
    this.bar.onRollOut = function () {
        if (!this._parent.down) {
            this.tint.setRGB(4473924);
        }
    };
    this.bar.onPress = function () {
        this._parent.down = true;
        startDrag (this, false, 0, 0, 0, this._parent._height - this._height);
    };
    this.bar.onRelease = function () {
        this._parent.down = false;
        stopDrag();
    };
    this.bar.onReleaseOutside = function () {
        this._parent.down = false;
        this.tint.setRGB(4473924);
        stopDrag();
    };
    this.bar.onEnterFrame = function () {
        if (this._parent.down) {
            _root[this._parent.box]._y = 20 - (this._y / this._parent.barperc);
        }
    };
};
MovieClip.prototype.controls = function () {
    this.lines = false;
    this.alphasort.onRelease = function () {
        tag_array.sort(alphaOrder);
        i = 0;
        while (i < tag_array.length) {
            tag = tag_array[i][0].toUpperCase();
            tagbox["tag_" + tag]._x = 0;
            tagbox["tag_" + tag]._y = i * 10;
            i++;
        }
    };
    this.numsort.onRelease = function () {
        tag_array.sort(numOrder);
        i = 0;
        while (i < tag_array.length) {
            tag = tag_array[i][0].toUpperCase();
            tagbox["tag_" + tag]._x = 0;
            tagbox["tag_" + tag]._y = i * 10;
            i++;
        }
    };
    this.straightlines.onRelease = function () {
        if (curvemode) {
            curvemode = false;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                if (dotbox.curves["curve_" + tag].viewable) {
                    dotbox.lines["line_" + tag].power();
                    dotbox.curves["curve_" + tag].power();
                }
                i++;
            }
        }
    };
    this.beziercurves.onRelease = function () {
        if (!curvemode) {
            curvemode = true;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                if (dotbox.lines["line_" + tag].viewable) {
                    dotbox.curves["curve_" + tag].power();
                    dotbox.lines["line_" + tag].power();
                }
                i++;
            }
        }
    };
    this.grayscale.onRelease = function () {
        if (colormode != 0) {
            colormode = 0;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                dotbox.lines["line_" + tag].colorMode();
                dotbox.curves["curve_" + tag].colorMode();
                tagbox["tag_" + tag].colorMode();
                i++;
            }
        }
    };
    this.coloralpha.onRelease = function () {
        if (colormode != 1) {
            colormode = 1;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                dotbox.lines["line_" + tag].colorMode();
                dotbox.curves["curve_" + tag].colorMode();
                tagbox["tag_" + tag].colorMode();
                i++;
            }
        }
    };
    this.colornum.onRelease = function () {
        if (colormode != 2) {
            colormode = 2;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                dotbox.lines["line_" + tag].colorMode();
                dotbox.curves["curve_" + tag].colorMode();
                tagbox["tag_" + tag].colorMode();
                i++;
            }
        }
    };
    this.showlines.onRelease = function () {
        if (this.lines) {
            this.lines = false;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                if (curvemode) {
                    dotbox.curves["curve_" + tag].viewable = true;
                    dotbox.curves["curve_" + tag].power();
                } else {
                    dotbox.lines["line_" + tag].viewable = true;
                    dotbox.lines["line_" + tag].power();
                }
                tagbox["tag_" + tag].lineon = false;
                tagbox["tag_" + tag].hilight = !tagbox["tag_" + tag].hilight;
                tagbox["tag_" + tag].testbutton._alpha = 0;
                tagbox["tag_" + tag].colorbox._alpha = 0;
                i++;
            }
        } else {
            this.lines = true;
            i = 0;
            while (i < tag_array.length) {
                tag = tag_array[i][0].toUpperCase();
                if (curvemode) {
                    dotbox.curves["curve_" + tag].viewable = false;
                    dotbox.curves["curve_" + tag].power();
                } else {
                    dotbox.lines["line_" + tag].viewable = false;
                    dotbox.lines["line_" + tag].power();
                }
                tagbox["tag_" + tag].lineon = true;
                tagbox["tag_" + tag].hilight = !tagbox["tag_" + tag].hilight;
                tagbox["tag_" + tag].testbutton._alpha = 10;
                tagbox["tag_" + tag].colorMode();
                i++;
            }
        }
    };
};
MovieClip.prototype.follow = function () {
    this.onEnterFrame = function () {
        this._x = _root._xmouse;
        this._y = _root._ymouse;
    };
};
Stage.addListener(stageListener);
Mouse.addListener(mouseListener);
Key.addListener(keyListener);
Stage.scaleMode = "noScale";
loginmode = true;
loadingmode = false;
vizmode = false;
colormode = 1;
curvemode = false;
currentuser = "";
tagboxdepth = 0;
timeoffset = -7;
months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
_root.attachMovie("login", "login", _root.getNextHighestDepth(), {_x:int(Stage.width / 2), _y:int(Stage.height / 2)});
_root.login.login();