/*
Copyright 2011, SeaJS v0.3.0
MIT Licensed
build time: Jan 17 21:52
*/

var module=module||{};module.seajs="0.3.0";
(function(H){function z(a,b){b.id=a;b.dependencies=p(b.dependencies,a);l[m(a)]=b}function A(a){for(var b=[],c=0,d=a.length,e;c<d;c++){e=a[c];l[m(e)]||b.push(e)}return b}function B(a){a=a||{deps:[]};return function(b){b=p(b,a.id);var c;if(I(a.deps,b)===-1||!(c=l[m(b)]))throw"Invalid module id: "+b;if(C(a,b)){var d=a;if(H.console)for(b=b;d;){b+=" <-- "+d.id;d=d.parent}return c.exports}if(!c.exports){d=c;b=a;var e=d.factory;if(q.call(e)==="[object Function]"){if(b=e.call(d,new B({id:d.id,parent:b,deps:d.dependencies}),
d.exports={},d))d.exports=b}else d.exports=e||{}}return c.exports}}function C(a,b){if(a.id===b)return true;if(a.parent)return C(a.parent,b);return false}function r(a,b,c){function d(){if(b)b(c?undefined:new B({id:"provide(["+a+"])",deps:a}))}a=A(p(a));if(a.length===0)return d();for(var e=0,f=a.length,h=f;e<f;e++)(function(D){J(D,function(){var n=(l[m(D)]||0).dependencies||[],s=n.length;if(s){n=A(n);h+=s;r(n,function(){h-=s;h===0&&d()},true)}--h===0&&d()})})(a[e])}function J(a,b){function c(){if(i){z(a,
i);i=null}j[d]&&delete j[d];b&&b()}var d=m(a);if(j[d])t(j[d],c);else{if(u)k={id:a,timestamp:E()};j[d]=K(d,c)}}function K(a,b){var c=document.createElement("script");t(c,function(){b&&b.call(c);try{if(c.clearAttributes)c.clearAttributes();else for(var d in c)delete c[d]}catch(e){}o.removeChild(c)});c.async=true;c.src=a;return o.insertBefore(c,o.firstChild)}function t(a,b){a.addEventListener("load",b,false);a.addEventListener("error",function(){b()},false)}function F(a){return(a=a.split("/").slice(0,
-1).join("/"))?a:"."}function v(a){if(L.call(w,a))return w[a];else{var b=a.split("/"),c=[],d,e,f;e=0;for(f=b.length;e<f;e++){d=b[e];if(d==".."){if(c.length===0)throw"Invalid module path: "+a;c.pop()}else d!=="."&&c.push(d)}return w[a]=c.join("/")}}function m(a){if(a===""||a.indexOf("://")!==-1)return a;if(a.charAt(0)==="/")a=a.substring(1);return v(x+"/"+a)+".js"}function p(a,b){var c,d=b?F(b)+"/":"";if(G(a)){var e=0,f=a.length;for(c=[];e<f;e++)c.push(v(a[e].indexOf(".")===0?d+a[e]:a[e]))}else if(q.call(a)===
"[object String]")c=v(a.indexOf(".")===0?d+a:a);return c}var q=Object.prototype.toString,L=Object.prototype.hasOwnProperty,G=Array.isArray?Array.isArray:function(a){return q.call(a)==="[object Array]"},I=Array.prototype.indexOf?function(a,b){return a.indexOf(b)}:function(a,b){for(var c=0,d=a.length;c<d;c++)if(a[c]===b)return c;return-1},E=Date.now||function(){return(new Date).getTime()},j={},i=null,k=null,u=!+"\v1",l={},g=document.getElementsByTagName("script");g=g[g.length-1];var x=F(g.hasAttribute?
g.src:g.getAttribute("src",4)),o=document.getElementsByTagName("head")[0];if(u)t=function(a,b){a.attachEvent("onreadystatechange",function(){var c=a.readyState;if(c==="loaded"||c==="complete")b()})};var w={},y=g.getAttribute("data-main");y&&r([y],function(a){a(y)});module.provide=r;module.declare=function(a,b,c){if(G(a)){c=b;b=a;a=""}if(u){if(!a){var d;a:{d=o.getElementsByTagName("script");for(var e,f=0,h=d.length;f<h;f++){e=d[f];if(e.readyState==="interactive"){d=e;break a}}d=void 0}if(d)a=d.src.replace(x+
"/","").replace(/\.js.*$/,"");else if(k)if(E()-k.timestamp<10)a=k.id}k=null}b={dependencies:b,factory:c};if(a){z(a,b);i=null}else i=b};module.reset=function(a){j={};l={};k=i=null;if(a)x=a}})(this);