<template>
  <div id='tournaments'>
    <h1>Tournaments</h1>
    <table v-if='this.$store.state.tournaments'>
      <thead>
        <tr>
          <th>id</th>
          <th>title</th>
          <th>description</th>
          <th>start date</th>
          <th>style</th>
          <th>state</th>
          <th>teams quantity / players in team</th>
        </tr>
      </thead>
      <tbody >
        <tr v-for="tournament in tournaments" v-on:click='showTournament(tournament.id)'>
          <td>{{tournament.id}}</td>
          <td>{{tournament.title}}</td>
          <td>{{tournament.description}}</td>
          <td>{{tournament.start_date}}</td>
          <td>{{tournament.style}}</td>
          <td>{{tournament.state}}</td>
          <td>
            <span>{{tournament.teams_quantity}}</span>
            /
            <span v-if='tournament.players_in_team > 0'>{{tournament.players_in_team}}</span>
            <span v-else>-</span>
          </td>
        </tr>
      </tbody>
    </table>
    <router-link :to="{name: 'tournamentNew'}">New</router-link>
  </div>
</template>

<script>
  import { router } from '../main'

  export default {
    name: 'Tournaments',
    computed: {
      tournaments () {
        return this.$store.state.tournaments
      }
    },
    methods: {
      showTournament (id) {
        router.push({name: 'tournamentInfo', params: { id: id }})
      }
    }
  }
</script>

<style scoped>
  tbody tr:hover {
    background-color: #41b883;
    cursor: pointer;
  }
</style>
