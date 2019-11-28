<template>
  <div v-if="session">
    <div v-if="!session.over">
      <h1>Où est {{ session.candidate }} ?</h1>

      <div>
        <img
          v-for="photo in session.photos"
          :key="photo"
          :src="'https://res.cloudinary.com/pretto-fr/image/upload/c_fill,g_face,q_auto,dpr_2.0,h_200,w_200' + photo"
          v-on:click="pick(photo)"
        />
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
  props: ["player"],

  data: function() {
    return {
      session: null
    };
  },

  methods: {
    async pick(photo) {
      const res = await fetch("http://localhost:4567/" + this.player, {
        method: "POST",
        body: JSON.stringify({ photo }),
        headers: {
          "Content-Type": "application/json"
        }
      });
      const { success } = await res.json();
      alert(success ? "OUI" : "NON");
      await this.reload();
    },
    async reload() {
      const res = await fetch("http://localhost:4567/" + this.player);
      const session = await res.json();
      this.session = session;
    },
    async restart() {
      await fetch("http://localhost:4567/" + this.player, { method: "DELETE" });
      await this.reload();
    }
  },

  async created() {
    await this.reload();
  }
};
</script>

<style scoped>
template {
  text-align: center;
}
img {
  height: 200px;
  width: 200px;
  margin: 20px;
}
</style>