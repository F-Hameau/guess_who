<template class='wrapper'>
  <div v-if="session">
    <div v-if="!session.over">
      <div v-if="!session.over && giveAnswer !='false'">
        <h1>Où est {{ session.candidate }} ?</h1>
        <div  class="container">
          <div class="photos">
            <img
              v-for="photo in session.photos"
              :key="photo"
              :src="'https://res.cloudinary.com/pretto-fr/image/upload/c_fill,g_face,q_auto,dpr_2.0,h_200,w_200/v1621342300/team/' + photo + '.jpg'"
              v-on:click="pick(photo)"
            />
          </div>
        </div>
      </div>
      <div v-if="giveAnswer ==='false'">
        <div class="container">
          <h1>Mauvaise réponse 😵</h1>
        </div>
        <h1>Voici {{ session.candidate }}</h1>
        <div>
          <img
            :key="response"
            :src="'https://res.cloudinary.com/pretto-fr/image/upload/c_fill,g_face,q_auto,dpr_2.0,h_200,w_200/v1621342300/team/' + answerPhoto + '.jpg'"
            />
       </div>
       <button v-on:click="answer">ok</button>
     </div>
     <div v-if="giveAnswer ==='correct'" class="container">
       <h1>Bonne réponse 🎉</h1>
     </div>
     <div v-if="!giveAnswer" class="container">
       <h1>Cliquez sur une photo</h1>
     </div>
    </div>
    <div v-if="session.over">
      <h1>C'est fini !!! ton score {{session.score}}</h1>
      <button v-on:click="restart">ENCORE</button>
    </div>
  </div>
</template>
<script>
export default {
  props: ["player","rounds"],
  data: function() {
    return {
      session: null,
      giveAnswer : null,
      answerPhoto : null
    };
  },
  methods: {
    async pick(photo) {
      const res = await fetch("https://guesswhopretto.herokuapp.com/" + this.player + "/"+ this.rounds, {
        method: "POST",
        body: JSON.stringify({ photo }),
        headers: {
          "Content-Type": "application/json"
        }
      });
      const response = await res.json();
      if(response.success){
        this.giveAnswer = 'correct';
        await this.reload();
      } else {
        this.giveAnswer = 'false';
        this.answerPhoto = response.answerPhoto
      }
    },
    async answer() {
     this.giveAnswer = null;
     await this.reload();
    },
    async reload() {
      const res = await fetch("https://guesswhopretto.herokuapp.com/" + this.player + "/"+ this.rounds);
      const session = await res.json();
      this.session = session;
    },
    async restart() {
      await fetch("https://guesswhopretto.herokuapp.com/" + this.player, {
        method: "DELETE"
      });
      await this.reload();
    }
  },
  async created() {
    await this.reload();
  }
};
</script>
<style scoped>
body {
  margin: 0;
  overflow: hidden;
}
.wrapper {
  position: relative;
  min-height: 100vh;
}
[class|="confetti"] {
  position: absolute;
}
.red {
  background-color: #e94a3f;
}
.yellow {
  background-color: #faa040;
}
.blue {
  background-color: #5fc9f5;
}
template {
  text-align: center;
}
img {
  height: 200px;
  width: 200px;
  margin: 20px;
}
.photos {
  max-width: 1000px;
}
.container {
  width: 100vw;
  justify-content: center;
  display: flex;
}
.success {
  transition: opacity 6s ease-out;
  opacity: 0;
}
@media screen and (max-width: 640px) {
  img {
    height: 100px;
    width: 100px;
    margin: 10px;
  }
}
@media screen and (max-width: 640px) {
  img {
    height: 100px;
    width: 100px;
    margin: 10px;
  }
  .photos {
    max-width: 250px;
  }
}
</style>
