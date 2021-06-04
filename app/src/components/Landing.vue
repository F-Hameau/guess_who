<template>
  <div>
    <form @submit="start">
      <h1>Qui es-tu ?</h1>
      <input type="text" v-model="name" placeholder="Superman" />
      <br />
      <button>Jouer avec les photos</button>
      <button v-on:click="all()">Jouer avec tous les collaborateurs</button>
      <button v-on:click="game2()">Jouer avec les noms</button>
    </form>
  </div>
</template>
<script>
export default {
  data() {
    return { name: "", gameName:"", gameAll: "" };
  },
  methods: {
    start(event) {
      event.preventDefault();
      this.$emit("start", this.name, this.gameName, this.gameAll);
    },
    game2(){
      this.gameName = true;
    },
    all(){
      this.gameAll = true;
    }
  }
};
</script>
<style>
input {
  border: none;
  border-radius: 20px;
  text-align: center;
  font-size: 16px;
  height: 25px;
  width: 180px;
  -webkit-appearance: none;
}
input:focus {
  outline: 0px transparent;
}
button {
  margin: 30px;
  background: #1098f7;
  font-weight: bold;
  border: none;
  font-size: 16px;
  padding: 10px 20px;
  border-radius: 20px;
  color: #fff;
}
button:hover {
  filter: grayscale(20%);
}
</style>
