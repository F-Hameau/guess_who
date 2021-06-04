<template class="wrapper">
  <div v-if="session">
    <div v-if="!session.over">
      <h1>Qui est sur cette photo ?</h1>
      <div v-if="!session.over">
        <div class="container">
          <img
            :key="photo"
            :src="
              'https://res.cloudinary.com/pretto-fr/image/upload/c_fill,g_face,q_auto,dpr_2.0,h_200,w_200/v1621342300/team/' +
                photo +
                '.jpg'
            "
          />
        </div>
        <form @submit="start">
          <input type="text" v-model="name" placeholder="Prénom Nom" />
          <br />
          <button v-on:click="check()">Valider</button>
        </form>
      </div>
      <div v-if="giveAnswer === 'false'">
        <div class="container">
          <h1>Mauvaise réponse 😵</h1>
        </div>
        <h1>C'est {{ session.candidate }}</h1>
        <div>
          <button v-on:click="answer">ok</button>
        </div>
      </div>
      <div v-if="giveAnswer === 'correct'" class="container">
        <h1>Bonne réponse 🎉</h1>
      </div>
    </div>
    <div v-if="session.over">
      <h1>C'est fini !!! ton score {{ session.score }}</h1>
      <button v-on:click="restart">ENCORE</button>
    </div>
  </div>
</template>
<script>
export default {
  props: ["player"],
  data: function() {
    return {
      session: null,
      photo: null,
      giveAnswer: null,
      name: null
    };
  },
  methods: {
    start(event) {
      event.preventDefault();
      this.$emit("start", this.name);
    },
    cleanUpSpecialChars(str) {
      return str
        .toLowerCase()
        .replace(/[éèêë]/g, "e")
        .replace(/[ç]/g, "c")
        .replace(/[ùûü]/g, "u")
        .replace(/[îï]/g, "i")
        .replace(/[^a-z0-9]/gi, ""); // final clean up
    },
    async check() {
      const candidate = this.session.candidate;
      let photo = "";
      if (this.cleanUpSpecialChars(candidate) == this.cleanUpSpecialChars(this.name)) {
        photo = this.photo;
      }

      const res = await fetch("http://localhost:4567/" + this.player + "/false", {
        method: "POST",
        body: JSON.stringify({ photo }),
        headers: {
          "Content-Type": "application/json"
        }
      });

      const response = await res.json();
      if (response.success) {
        this.giveAnswer = "correct";
        await this.reload();
      } else {
        this.giveAnswer = "false";
      }
    },
    async answer() {
      this.giveAnswer = null;
      await this.reload();
    },
    async reload() {
      const res = await fetch("http://localhost:4567/" + this.player + "/false");
      const session = await res.json();
      this.session = session;
      this.photo = session.answerPhoto;
      this.name = null;
    },
    async restart() {
      await fetch("http://localhost:4567/" + this.player, {
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
