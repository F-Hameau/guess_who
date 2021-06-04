<template>
  <div id="app">
    <Game v-if="name  && !gameName" :player="name"  :rounds="gameAll"/>
    <GameName v-if="name && gameName" :player="name" />
    <Landing v-if="!name" v-on:start="startGame" />
  </div>
</template>
<script>
import Game from "./components/Game.vue";
import GameName from "./components/GameName.vue";
import Landing from "./components/Landing.vue";
export default {
  name: "app",
  components: {
    Landing,
    Game,
    GameName
  },
  data() {
    return { name: null, gameName: null , gameAll: null};
  },
  methods: {
    startGame(name, gameName, gameAll) {
      this.name = name,
      this.gameName = gameName;
      if(gameAll == true)
      {
        this.gameAll = gameAll;
      } else {
        this.gameAll = false;
      }
    }
  }
};
</script>
<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: rgb(230, 230, 230);
  margin-top: 60px;
}
body {
  margin: 0;
  min-height: 100vh;
  background: linear-gradient(#35ae77, #2faeb1);
}
</style>
